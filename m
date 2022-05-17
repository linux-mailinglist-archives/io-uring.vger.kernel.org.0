Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCD752A04D
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 13:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiEQLV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 07:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345170AbiEQLUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 07:20:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576C4C34;
        Tue, 17 May 2022 04:20:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E45C71F37E;
        Tue, 17 May 2022 11:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652786441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pli78y9ISzE9ffVu67v6MhiBzKIfcc8d6E3oeSONsUY=;
        b=GO4mzVWZbtmykBeSm1gAU4G96Bkdpi3GEeuZYEegZEV+VUU8magWVdc/VwNmKk5pYe5xzt
        N15lD9M8wkf1UtrvyMUlRqIUBf6eL2gQkyVh8ScSIKoB6+zb6w90lwwxyoiX6kc10C9Nz9
        PvDbfoVZuvUx6DaAY6FnxiqQz34kbzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652786441;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pli78y9ISzE9ffVu67v6MhiBzKIfcc8d6E3oeSONsUY=;
        b=VnHL6lfGVoZ7dQAbkzz+WM+AQp17yyExDv8dNYo6CTiIdwOcviwCI8nvg8E+sWejDuqkoM
        E3EwvTz4MRmWmdCg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D2E5C2C141;
        Tue, 17 May 2022 11:20:41 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2CA93A0631; Tue, 17 May 2022 13:20:36 +0200 (CEST)
Date:   Tue, 17 May 2022 13:20:36 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 07/16] fs: split off need_file_update_time and
 do_file_update_time
Message-ID: <20220517112036.xln2r72wbhja2sro@quack3.lan>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-8-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon 16-05-22 09:47:09, Stefan Roesch wrote:
> This splits off the functions need_file_update_time() and
> do_file_update_time() from the function file_update_time().
> 
> This is required to support async buffered writes.
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

...
> +int file_update_time(struct file *file)
> +{
> +	int err;
> +	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
> +
> +	err = need_file_update_time(inode, file, &now);
> +	if (err < 0)
> +		return err;
> +
> +	return do_file_update_time(inode, file, &now, err);
> +}
>  EXPORT_SYMBOL(file_update_time);

I guess 'ret' would be a more appropriate variable name than 'err'.
Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
