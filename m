Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9476D7FA8
	for <lists+io-uring@lfdr.de>; Wed,  5 Apr 2023 16:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbjDEOgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 10:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbjDEOgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 10:36:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E934C13
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 07:36:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 70D3A2069F;
        Wed,  5 Apr 2023 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680705383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L3cYlYfzn53KO9z+kNOLYBWD5BZyyOyXVz/GyvQmPp4=;
        b=ZDvp8kRR80S/mUoIkmtRvem+J9JZsy0cicUPixfZivNBEHt+IuqL9gfURkG56/LibShbvi
        Ty5TBrY1fAuh0XzI7Z459ct0GAhnkorpQm9cUjbMuDyry6BJeyeilOt9uFxYc7No5dJFhA
        I7bY2UYRNUR7bQNnSWWjBt3JWeZlLts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680705383;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L3cYlYfzn53KO9z+kNOLYBWD5BZyyOyXVz/GyvQmPp4=;
        b=PybSpXDqygnWTVpl1zhDD6KHo+EQKaa7F61l4d6wAo6hp2LPUSE+ttWNOXJLePCkiEpMmQ
        ipZo9n3+BE8vrKBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED4DE13A31;
        Wed,  5 Apr 2023 14:36:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id apwdKmaHLWRZEAAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 05 Apr 2023 14:36:22 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH] io_uring/uring_cmd: assign ioucmd->cmd at async prep time
References: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
Date:   Wed, 05 Apr 2023 11:36:20 -0300
In-Reply-To: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk> (Jens Axboe's
        message of "Wed, 5 Apr 2023 08:23:15 -0600")
Message-ID: <875yaaz997.fsf@suse.de>
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

Jens Axboe <axboe@kernel.dk> writes:

> Rather than check this in the fast path issue, it makes more sense to
> just assign the copy of the data when we're setting it up anyway. This
> makes the code a bit cleaner, and removes the need for this check in
> the issue path.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi
