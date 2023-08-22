Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D8C784CCB
	for <lists+io-uring@lfdr.de>; Wed, 23 Aug 2023 00:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjHVWTz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 18:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjHVWTy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 18:19:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E4CCCB
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 15:19:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C0CE1F390;
        Tue, 22 Aug 2023 22:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692742790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nCWf/cVQYFf0Kfud4sPeTM25t3TpgG6NUVf7VT/C8qY=;
        b=yATjf9XTVil0VfLJ2fKn8XtlpHwrbk7zAVlvJvi9wQ9VwDLWfLz4UBkZX6O6j0wm2WW3EK
        loU2SJhg8bwJ8iy/gDVgZkzMX0YEp+kZjvmH0FdRB1bUQbf8Sr/qtZkGxCHHtwWoFtofj+
        SQey/2N8vqZl68Got0rxq2v7RaBQyNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692742790;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nCWf/cVQYFf0Kfud4sPeTM25t3TpgG6NUVf7VT/C8qY=;
        b=j80qML5X4a/sc4Qayuxve1HJ6Q6v5UZYIklr5GGjDYQd4urxNJfG36aMgez/EugNlZfvt9
        ScC4WTIFNpTZJ0CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D373132B9;
        Tue, 22 Aug 2023 22:19:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cbmGOoU05WRkbQAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 22 Aug 2023 22:19:49 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix locking for MSG_RING and IOPOLL targets
In-Reply-To: <20230822205425.1385767-1-ovt@google.com> (Oleksandr Tymoshenko's
        message of "Tue, 22 Aug 2023 20:54:24 +0000")
References: <20230119180225.466835-1-axboe@kernel.dk>
        <20230822205425.1385767-1-ovt@google.com>
Date:   Tue, 22 Aug 2023 18:19:48 -0400
Message-ID: <87o7iyn2ij.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Oleksandr Tymoshenko <ovt@google.com> writes:

> Hello,
>
> Does this patchset need to be backported to 6.1?

Yes. Seems to be missing in linux-6.1.y and it is a security fix.  Do you want to send
a backport?

-- 
Gabriel Krisman Bertazi
