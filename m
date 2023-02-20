Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BC169CFBF
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjBTOxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjBTOxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:53:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD51A969
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:53:37 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F3FDD2276E;
        Mon, 20 Feb 2023 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676904815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RV4zCY/uDa/fcCxapSxwiIdxpBXq5NXlfb6tBD/rNZ4=;
        b=ymPfmTu35Zz1LGb20ADCnTuo3ZREf6/OLg6AVuqvwRjuFtKSrI6FxQdUD5Q2RehSf4uQH/
        VudKtTlktf3g/QDTiBuuI4x9WpK/gei8gkK5A3G1OwjYRTTgWcg6HIPamJ0t8NB9ARIeHx
        fd/BtHhd9F96Cp66Xv9YK2oNqJ+OxVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676904815;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RV4zCY/uDa/fcCxapSxwiIdxpBXq5NXlfb6tBD/rNZ4=;
        b=vaRVnsLjAkdmndL4wGt/UGHzqNI1qslE+as3jkdPmQlmJ0U5WdqeRyhMyGIWOI8hy1GhoW
        X/m8Wf9ZybIbexCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84949134BA;
        Mon, 20 Feb 2023 14:53:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BNKuE2+J82OUQQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 20 Feb 2023 14:53:35 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 1/1] io_uring/rsrc: fix a comment in
 io_import_fixed()
References: <5b5f79958456caa6dc532f6205f75f224b232c81.1676902343.git.asml.silence@gmail.com>
Date:   Mon, 20 Feb 2023 11:53:33 -0300
In-Reply-To: <5b5f79958456caa6dc532f6205f75f224b232c81.1676902343.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Mon, 20 Feb 2023 14:13:52 +0000")
Message-ID: <87ttzgcrrm.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
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

Pavel Begunkov <asml.silence@gmail.com> writes:

> io_import_fixed() supports offsets, but "may not" means the opposite.
> Replace it with "might not" so the comments rather speaks about
> possible cases.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi
