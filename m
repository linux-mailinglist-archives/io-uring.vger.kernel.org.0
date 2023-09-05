Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36384792A53
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbjIEQev (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 12:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354536AbjIEMYb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 08:24:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA841A8;
        Tue,  5 Sep 2023 05:24:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E70811FD8E;
        Tue,  5 Sep 2023 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693916666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7M4X3ltwI/VM1laJUfqoL6rnCUoo+tPTHyGF9EcSb4=;
        b=BSh4tK42t37/hjB81tIVJaoFbkEnB6TT/FK0HXE+uFX6Bw5xI1/G+94VWY4bjgEVS1GsLN
        9CesqlourNuHjoPH/ZzJwE87JSVCVcWft8zO/5qxhY2n1FjhWR88pJW0EVVp2oB5TwVjuI
        9J3ZjN23vadJmaQ7RXmH+8Uzr0YfeUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693916666;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7M4X3ltwI/VM1laJUfqoL6rnCUoo+tPTHyGF9EcSb4=;
        b=Pvu8ACuOSzN6VLftdOMZeeF6kb0rzpSRVD0zDfew662reQ86XWGhE0rRmAViHV6je5hvcE
        7iBXBna3vnmbFNAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B027213911;
        Tue,  5 Sep 2023 12:24:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YS15Jfod92QpEwAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 05 Sep 2023 12:24:26 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v4 08/10] io_uring/cmd: Introduce
 SOCKET_URING_OP_GETSOCKOPT
In-Reply-To: <20230904162504.1356068-9-leitao@debian.org> (Breno Leitao's
        message of "Mon, 4 Sep 2023 09:25:01 -0700")
Organization: SUSE
References: <20230904162504.1356068-1-leitao@debian.org>
        <20230904162504.1356068-9-leitao@debian.org>
Date:   Tue, 05 Sep 2023 08:24:25 -0400
Message-ID: <87a5u0byfa.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> where a sockptr_t is either userspace or kernel space, and handled as
> such.
>
> Differently from the getsockopt(2), the optlen field is not a userspace
> pointers. In getsockopt(2), userspace provides optlen pointer, which is
> overwritten by the kernel.  In this implementation, userspace passes a
> u32, and the new value is returned in cqe->res. I.e., optlen is not a
> pointer.
>
> Important to say that userspace needs to keep the pointer alive until
> the CQE is completed.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

IMO, this looks much cleaner with most of the bpf and socket logic under
net/.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks!


-- 
Gabriel Krisman Bertazi
