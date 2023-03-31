Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD12B6D2180
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjCaNfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 09:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjCaNfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 09:35:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9DB1EA23;
        Fri, 31 Mar 2023 06:35:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE3371F38C;
        Fri, 31 Mar 2023 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680269711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBTTw4FmgIAb/cjVvDNfUQ4cZmC0+48pwsVLVqEzmQk=;
        b=djiMXrm6ONVzenkSncn2vz9NCUmPQaX1n+i5uNfcskIAo6tG8LAhsZ4/Rf61Xj1zteHzrn
        jvQqtgaUCqDHzxuMFsKtrhvtPcR+Jd+Ct3VEH+QgYS5TilNm0Dmw0pUmEPxbIlN4ptfG1K
        Nt91p8d6XJnNPu55RAyXhApzol+1b8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680269711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBTTw4FmgIAb/cjVvDNfUQ4cZmC0+48pwsVLVqEzmQk=;
        b=2iMsWtPSnK7zOBkPNEfgmRjP5tgL4KjAwhwhOmsj8P4JsKOfCB6aGVuoExsrJ+eqgbtL1X
        JMO1s2xo8wye3lBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DD6C133B6;
        Fri, 31 Mar 2023 13:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OHjiDY/hJmQ7TQAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 31 Mar 2023 13:35:11 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/11] optimise registered buffer/file updates
References: <cover.1680187408.git.asml.silence@gmail.com>
Date:   Fri, 31 Mar 2023 10:35:09 -0300
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com> (Pavel Begunkov's
        message of "Thu, 30 Mar 2023 15:53:18 +0100")
Message-ID: <87h6u111te.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Pavel,

Pavel Begunkov <asml.silence@gmail.com> writes:
> Updating registered files and buffers is a very slow operation, which
> makes it not feasible for workloads with medium update frequencies.
> Rework the underlying rsrc infra for greater performance and lesser
> memory footprint.
>
> The improvement is ~11x for a benchmark updating files in a loop
> (1040K -> 11468K updates / sec).

Nice. That's a really impressive improvement.

I've been adding io_uring test cases for automated performance
regression testing with mmtests (open source).  I'd love to take a look
at this test case and adapt it to mmtests, so we can pick it up and run
it frequently.

is it something you can share?

-- 
Gabriel Krisman Bertazi
