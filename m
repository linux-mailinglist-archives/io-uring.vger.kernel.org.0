Return-Path: <io-uring+bounces-13383-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CD2/AMrcCmpV8wQAu9opvQ
	(envelope-from <io-uring+bounces-13383-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:32:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAB5569C4C
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E8FD301DBB0
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD8A3E5A17;
	Mon, 18 May 2026 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6sihm9e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A843E16AD
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 09:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779096566; cv=none; b=RF+aRhe5JELJsu6jHjMsok/ytVa72qfz6wbc5p8AY/uUbP+Be7tperO0yRKWUvtWNv7VqDgWEK13Zf6rCIuqbSqNVx+lR+2BoOo3heqTqXk+6fuP276lA1uEraT71LJFH3S9xmVg9uUaVxFPCxBK39YbfTE96U/NYlOUbSkMyXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779096566; c=relaxed/simple;
	bh=r0/J3kQR5yeiimzsreh80xsM6C9KNUlXaQl9kU29TUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJuiQhBUYktIesJLl9/GDmx3+s9caz2vLoT6aXvHDrq+A3VI6NV/c6b+0CdE32qP72tCr1r/UUMj0Hwpi5Vkb88ayNxNMpMc5KHKq6ogb1S1zToLupQGG1lfe3o4UzgwImXCbynlZLzoUrNl2YxqtH5wB7XbhJs2d9UTeSabw2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6sihm9e; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso27584995e9.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 02:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779096563; x=1779701363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CDwQwZfzQ+v4zAM7BuOooX+kRgbnUOKOzvArP/cGiqU=;
        b=B6sihm9e1ft7GQekyoXBNogAiSuG3QW34W93kkgKsnnNNCDv5J6PKfz6fFTivh/Gss
         0aeFH+dUmUOPPFDfzXy+bVNg8/JbM8bVScJP8cGlfl6x6NdamFBBcJNpcrzmbTnSBFQP
         xLI9pHzOFEB+/TAjplJRJusm7Il+vpUm9nUJLFPj2xfh1LlIzWrqsltuOIr2zo56HwCq
         t9Gr2zAI2FqfHBmRgBbouS+cBThIAKbF3/6s37Ifde0OdwJ76X2qqp/elc7yo+1FUyO/
         5lCFkIBDoLApQ4ZPiUA5LuXTZHogsG91YKqTcgJs8DHnSw/kXU9BQMdHeSsyU+OQoV7g
         6vEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779096563; x=1779701363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDwQwZfzQ+v4zAM7BuOooX+kRgbnUOKOzvArP/cGiqU=;
        b=r6FlWU7r66oNMNu/m+ImgG/688PQvwxHtUb07kcf77C3W/zqi5mJbnv0lSihX0DWth
         m3RKAYQB+GZg9bd1LE+RGbqMLh7aohssloCP5t26AG622DMmwacYSMeqTh3oEWVW+Az7
         5GIgIxkoyINaR8Nys13LNZEvYqDIzv2TIJIqceD6dMEBrTre1GBAwumHxGWhf2o6ntF3
         Kz3H82jhW9nBgHAVD+0xHGbDk5tfxukdtNgbFIiZf/gHAtOa2M/2F1IE1+auZaBsLxb/
         mYufB4LX0BvBA1/IkND5IeXgzj3SUiP9rPh+C8WjAkCxPYcOEK+yc19XQIFCk23wRRKc
         G85Q==
X-Forwarded-Encrypted: i=1; AFNElJ+D0UKoU+Bbw0m591nhwH6qPFYzNQqaBfbrTEUkfke8RmcadnqwuInf1IAbfSfV1BDmoruOZO/aoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQm74sRIgMSSeBnG743gThr0TrAJURfc5++aUH5GAWGv/3wCO1
	RKnLpq/NYUQgAqVM7mW/0Qf0McexObRFT/kT7kKQZVDMLUn0wByrbLy0
X-Gm-Gg: Acq92OHR/Z6/QwGPeTd6csNol8IiVXyk0dZxI0vHtxzuqx3k5SaaJ5r8XCtvCZANWvF
	yarvrYysOwcosw8Mf1Tt95yXV68hHDeYUb03YIJpiYJj+RAhmSZTyao1dslrNiP1YZp2/5y8q2G
	C0rG4NgY+oby5PWTLlgQtLTxgLAFRWIP1lrPX0m7CYAe+4mkIYLZTR5s8DWofHSqpz3aToi24Kf
	O1SIlNdWDHM7ZmPNgfVaVbqJjl38KRJx+d4n1VIS5znUiqESUqhVAP1ay4HmxD/u4BNmmIvFvJu
	QxpeHBOlug7+MNAIhn2AyKqbJYWUUConT08YUHVmJ4L4AmMIjGoDVFsTBH26skPjrlDDIolgNOJ
	71gazHdeJUmLurdWD28Jtqft7GtRvKxyO/iaCf2fXUMdtduuopuMFUfrrujCSnF8y8Oz1RzhhJ4
	6GcwrNv1utWKZjxVwD0qhavxvHcSW/QjGzT+ifLTbjZlu86fmFqFoel/ldJeGeDaRRfBOwUpR9S
	n4hofhRhU8NIiM00dCtNS67c7a4iqvvaPOfXOvOyfcR2y//jUo38u7Kk2MvvtBy2g8+2A==
X-Received: by 2002:a05:600c:34cc:b0:48e:635a:18d7 with SMTP id 5b1f17b1804b1-48fe59b047bmr240818345e9.0.1779096563202;
        Mon, 18 May 2026 02:29:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6e9b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe582e3sm88451385e9.15.2026.05.18.02.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:29:22 -0700 (PDT)
Message-ID: <50ed7240-d8d3-4816-bcc9-ce8adbbbf841@gmail.com>
Date: Mon, 18 May 2026 10:29:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
 <20260513083817.GC6461@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260513083817.GC6461@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6FAB5569C4C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13383-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 09:38, Christoph Hellwig wrote:
> FYI, I really want SGL support before this get merged, but ignoring that
> for now:

I was hoping to let Samsung guys to send a follow up they already have,
but I'll ask them to have about taking it into this patch set.

>> +struct nvme_dmabuf_map {
>> +	struct io_dmabuf_map base;
>> +	dma_addr_t *dma_list;
>> +	struct sg_table *sgt;
>> +	unsigned nr_entries;
> 
> I'd make dma_list a variable-sized array at the end of the struture to avoid
> an extra allocation and pointer derefernece.

Ok

>> +static void nvme_dmabuf_map_sync(struct nvme_dev *nvme_dev, struct request *req,
>> +				 bool for_cpu)
>> +{
>> +	int length = blk_rq_payload_bytes(req);
>> +	struct device *dev = nvme_dev->dev;
>> +	enum dma_data_direction dma_dir;
>> +	struct bio *bio = req->bio;
>> +	struct nvme_dmabuf_map *map;
>> +	dma_addr_t *dma_list;
>> +	int offset, map_idx;
>> +
>> +	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>> +	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
>> +	dma_list = map->dma_list;
>> +
>> +	offset = bio->bi_iter.bi_bvec_done;
>> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
>> +	length += offset & (NVME_CTRL_PAGE_SIZE - 1);
> 
> Please initialize the variable at declaration time and use or add proper
> helpers to simplify this:

> static inline struct nvme_dmabuf_map *
> to_nvme_dmabuf_map(struct io_dmabuf_map *map)
> {
> 	return container_of(map, struct nvme_dmabuf_map, base);
> }
> 
> ....
> 
> 	enum dma_data_direction dma_dir = rq_dma_dir(req);
> 	struct device *dev = nvme_dev->dev;
> 	struct bio *bio = req->bio;
> 	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
> 	dma_addr_t *dma_list = map->dma_list;
> 	int offset = bio->bi_iter.bi_bvec_done;
> 	int mmap_idx = offset / NVME_CTRL_PAGE_SIZE;
> 	int length = blk_rq_payload_bytes(req) +
> 		offset & (NVME_CTRL_PAGE_SIZE - 1);
> 
> Also a lot of these ints sound like they should be unsigned.

Ok

>> +
>> +	while (length > 0) {
>> +		u64 dma_addr = dma_list[map_idx++];
>> +
>> +		if (for_cpu)
>> +			__dma_sync_single_for_cpu(dev, dma_addr,
>> +						  NVME_CTRL_PAGE_SIZE, dma_dir);
>> +		else
>> +			__dma_sync_single_for_device(dev, dma_addr,
>> +						     NVME_CTRL_PAGE_SIZE,
>> +						     dma_dir);
>> +		length -= NVME_CTRL_PAGE_SIZE;
>> +	}
>> +}
> 
> Nothing should be using these __dma_sync helpers that are internal
> details. Using them means you call into sync code that should be skipped
> on most common server class systems.

Yeah, the kernel test robot already flagged it as well

> Also the for_cpu argument is a bit ugly.  I'd rather have separate
> routines as in the core dma-mapping code, even if that means a little bit
> of code duplication.
> 
>> +static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
>> +					     struct nvme_queue *nvmeq)
>> +{
>> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>> +	int length = blk_rq_payload_bytes(req);
>> +	u64 dma_addr, prp1_dma, prp2_dma;
>> +	struct bio *bio = req->bio;
>> +	struct nvme_dmabuf_map *map;
>> +	dma_addr_t *dma_list;
>> +	dma_addr_t prp_dma;
>> +	__le64 *prp_list;
>> +	int i, map_idx;
>> +	int offset;
>> +
>> +	nvme_dmabuf_map_sync(nvmeq->dev, req, false);
>> +
>> +	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
>> +	dma_list = map->dma_list;
>> +
>> +	offset = bio->bi_iter.bi_bvec_done;
>> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
>> +	offset &= (NVME_CTRL_PAGE_SIZE - 1);
>> +	prp1_dma = dma_list[map_idx++] + offset;
> 
> Same comments as for the sync helper above.
> 
>> +	length -= (NVME_CTRL_PAGE_SIZE - offset);
>> +	if (length <= 0) {
>> +		prp2_dma = 0;
>> +		goto done;
>> +	}
>> +
>> +	if (length <= NVME_CTRL_PAGE_SIZE) {
>> +		prp2_dma = dma_list[map_idx];
>> +		goto done;
>> +	}
>> +
>> +	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=
>> +	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
>> +		iod->flags |= IOD_SMALL_DESCRIPTOR;
>> +
>> +	prp_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
>> +			&prp_dma);
>> +	if (!prp_list)
>> +		return BLK_STS_RESOURCE;
>> +
>> +	iod->descriptors[iod->nr_descriptors++] = prp_list;
>> +	prp2_dma = prp_dma;
> 
> And I really hate how this duplicates all the nasty PRP building logic,
> although right now I don't have a good answer to that.
> 
>> +static inline bool nvme_rq_is_dmabuf_attached(struct request *req)
>> +{
>> +	if (!IS_ENABLED(CONFIG_DMABUF_TOKEN))
>> +		return false;
>> +	return req->bio && bio_flagged(req->bio, BIO_DMABUF_MAP);
>> +}
> 
> This is something that should go into the block layer.

I'll move it

-- 
Pavel Begunkov


