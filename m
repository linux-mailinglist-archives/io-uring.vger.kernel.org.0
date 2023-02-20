Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A469CFA0
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjBTOpl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjBTOpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:45:40 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4D9A5E4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:45:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2BC7520155;
        Mon, 20 Feb 2023 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676904337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLMWt4DJEoLoIGBt435mazCE5HdxhhAENzSaX63u3jM=;
        b=KU7RwPYRJOdAwPESmRgAUM1oSjXx6AEpdHjHTt5fqHIOCmtLULCjF80EbdWU3UTsldEzq+
        Ogdb3DQC8Yn2BfGm7PXtWx+cAs5XiOowEZRLLlbvjJESZg3bWdPFE/upvZS9VGbusPnkAT
        pvfmjBL8mQxnPW0eWiYmIZ+L0qvK2x8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676904337;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLMWt4DJEoLoIGBt435mazCE5HdxhhAENzSaX63u3jM=;
        b=KxtwDAhwuWxsm3Eh5y8p8kNv/xRl+NgV40zhwBXlwSnKYlsjbnh1xgQLxSP5S1xoDNogqn
        WSol/nSAaLMlkFDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B060B139DB;
        Mon, 20 Feb 2023 14:45:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Stp2HpCH82M3PQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 20 Feb 2023 14:45:36 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] test/buf-ring: add test for buf ring occupying
 exactly one page
References: <20230218184618.70966-1-wlukowicz01@gmail.com>
Date:   Mon, 20 Feb 2023 11:45:34 -0300
In-Reply-To: <20230218184618.70966-1-wlukowicz01@gmail.com> (Wojciech
        Lukowicz's message of "Sat, 18 Feb 2023 18:46:18 +0000")
Message-ID: <875ybwe6pd.fsf@suse.de>
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

Wojciech Lukowicz <wlukowicz01@gmail.com> writes:

> This shows an issue with how the kernel calculates buffer ring sizes
> during their registration.
>
> Allocate two pages, register a buf ring fully occupying the first one,
> while protecting the second one to make sure it's not used. The
> registration should succeed.
>
> mmapping a single page would be a more practical example, but wouldn't
> guarantee the issue gets triggered in case the following page happens
> to be accessible.
>
> Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
> ---
> This is a failing test, needs the patch I sent earlier.


Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi
