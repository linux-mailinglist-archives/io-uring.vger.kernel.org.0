Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE15884B7
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 01:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiHBXZW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 19:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiHBXZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 19:25:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859665F40;
        Tue,  2 Aug 2022 16:25:20 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.110.15])
        by gnuweeb.org (Postfix) with ESMTPSA id EF8CE8060F;
        Tue,  2 Aug 2022 23:25:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1659482719;
        bh=+au6dQlBqQIHJQgyGdW4Nb34wf6bajMRt7oudmw/yo4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gFXTqEcTqyl0/ej7COyaD6isAwgmie7aA2fAMxbf4A3wZbyjrmHLRchIVlj/RsV/p
         OMXY0fANBx40iqGa2gX/Cxvx3H864UliDnl7DECdpDlkON2s/83iPgnLvxWKHND1wT
         BotuQS5+le1vHJzh2whp1N2fVFBPHbDMwB/iJulNHL2dSwuJLzXIA44Y1nGxr7v/sf
         nnKm63FpaQEQQZudRwEsDNoDrzZfGRAE8xU+xvfRAPqdpO4BCt2CHRRuLUoLHmyLkM
         DpWO0SFIRp9B615YZ6mNwLgE1oqW0Rm6WocN8i+49AmmIfMAylZLBBhDyHLpewIm8c
         BPf/hx2vhUoiw==
Message-ID: <05dfe735-d146-ad5c-2f98-940032fd1f48@gnuweeb.org>
Date:   Wed, 3 Aug 2022 06:25:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv2 6/7] io_uring: add support for dma pre-mapping
Content-Language: en-US
To:     Keith Busch <kbusch@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Keith Busch <kbusch@kernel.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Block Mailing List <linux-block@vger.kernel.org>,
        Linux fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux NVME Mailing List <linux-nvme@lists.infradead.org>
References: <20220802193633.289796-1-kbusch@fb.com>
 <20220802193633.289796-7-kbusch@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220802193633.289796-7-kbusch@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/22 2:36 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide a new register operation that can request to pre-map a known
> bvec to the requested fixed file's specific implementation. If
> successful, io_uring will use the returned dma tag for future fixed
> buffer requests to the same file.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
[...]
> +static int io_register_map_buffers(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_map_buffers map;
> +	struct io_fixed_file *file_slot;
> +	struct file *file;
> +	int ret, i;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = get_map_range(ctx, &map, arg);
> +	if (ret < 0)
> +		return ret;
> +
> +	file_slot = io_fixed_file_slot(&ctx->file_table,
> +			array_index_nospec(map.fd, ctx->nr_user_files));
> +	if (!file_slot || !file_slot->file_ptr)
> +		return -EBADF;

The @file_slot NULL-check doesn't make sense. The definition of
io_fixed_file_slot() is:

static inline struct io_fixed_file *
io_fixed_file_slot(struct io_file_table *table, unsigned i)
{
         return &table->files[i];
}

which takes the address of an element in the array. So @file_slot
should never be NULL, if it ever be, something has gone wrong.

If you ever had @ctx->file_table.files being NULL in this path, you
should NULL-check the @->files itself, *not* the return value of
io_fixed_file_slot().

IOW:

...
	// NULL check here.
         if (!ctx->file_table.files)
                 return -EBADF;

         file_slot = io_fixed_file_slot(&ctx->file_table,
                                        array_index_nospec(map.fd, ctx->nr_user_files));
         if (!file_slot->file_ptr)
                 return -EBADF;
...

>   	for (i = 0; i < ctx->nr_user_files; i++) {
> -		struct file *file = io_file_from_index(&ctx->file_table, i);
> +		struct io_fixed_file *f = io_fixed_file_slot(&ctx->file_table, i);
> +		struct file *file;
>   
> -		if (!file)
> +		if (!f)
>   			continue;

The same thing, this @f NULL-check is not needed.

> -		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
> +		if (f->file_ptr & FFS_SCM)
>   			continue;
> +
> +		io_dma_unmap_file(ctx, f);
> +		file = io_file_from_fixed(f);
>   		io_file_bitmap_clear(&ctx->file_table, i);
>   		fput(file);
>   	}

-- 
Ammar Faizi
