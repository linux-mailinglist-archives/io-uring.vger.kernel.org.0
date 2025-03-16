Return-Path: <io-uring+bounces-7088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C13A634BB
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 09:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C873D1704DA
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 08:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B6E191F6D;
	Sun, 16 Mar 2025 08:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="FrU5Z/Ve"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B352218DB0D
	for <io-uring@vger.kernel.org>; Sun, 16 Mar 2025 08:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742115004; cv=none; b=B6jtnhAhausO/Yp3l3k7o+uR0QomryEd5HQpVGI6JQ9JQRWwSSHE12NXZ1LgXIPsk3WsbgMb3F7cA9J2fK1I+pM8cX9JdUmsvpC2lnT4sAb87kJ+M55L897gC3cRXIB+avAr+lVZJFPENHYMlaiFKvPKxoflCot4yb7MPwucG0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742115004; c=relaxed/simple;
	bh=MlPySl3ACm5OC8MT1lGjuC4BtV8C3P3CkbQqd9j9HqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDkzpBfwOtM5MHWbrpDp/BA2bA+1gIXum5BVqqMv3tyunQxMR+N5G7dic95vQ52APgtLFoSiyCIDVbBZTH6rDfnhfTHB9Ywz/im4HG35yTYkwtekZ7Wprq7ukyx4zO2RPLZ4aJ0rBEqCLvgRTpyWIoLM7XHtHOO8Vf4E2C/rK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=FrU5Z/Ve; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223a7065ff8so12180905ad.0
        for <io-uring@vger.kernel.org>; Sun, 16 Mar 2025 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1742115002; x=1742719802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=soOsMjUDX0L3z68pN83CLYXGQKPqqXJHBRzUH/+iQu4=;
        b=FrU5Z/Ve4KI2EJ5dpYWsk+rRaYpNJii8NKRM/FOkVFL56m5v4V/LXT6hZ7Z/5jmH7b
         CqWGqqRIymLu+1lUIFkJ7+tkUm3maYzbsjN8VGcmxSFhWq5Y5LlRfN4/Pa2+emh3Bf2I
         6arc1LUM6ABEzHBev6naLyPISV3l4hqRXpM7uDLX3dvCwBrynGgihqc91EW5ImUR8kgf
         iM4Z4Rm5wsvGTm2ylupZjwKLcGZGoRNFfAZXaM7GVXIUFVD8mTAlW2y8mJ2QwsE26m8y
         cdOBkwN88PGyXHtHXjid/joZGEnLqiyUSFfs8sKHcwyRfUYHwnRKxP86PIoOEPWtvG4M
         LNtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742115002; x=1742719802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=soOsMjUDX0L3z68pN83CLYXGQKPqqXJHBRzUH/+iQu4=;
        b=midOLIoiBh+MhIh9RGQtA/H8F4roOFtv3yPi13tUErScmfo2J7unQ4eyBdSzOhD1ku
         Q1usnlsLObixMmSGA5y5p/X9wvPLQutONc6caK9rezHqmd9e31m6Nz2/DDDVAKXkDxHr
         /wR12GoNAujgOW0yC2kD9a31VHPE0DmZiavcGdnwRLd0ZMr1Q+3qYyFoeqQQH/o5np6C
         ze7Wa77pH6PTULseaQ/8KyoyeUnEE0MYmMO3SA7N8x6QrKo3V2E3Au+nOGCb8Nloaw5I
         /Iad7cf64wI9rsGGigSxj6H4ZJUl4co/HB/zcPRHjneeiRNlGJipZuZ5dXdViWMsSqmc
         dY/A==
X-Forwarded-Encrypted: i=1; AJvYcCVZX3YoKOpJcgW0R8GYQ+77bXWyHJc79mSpDrUaFsfsX7KmpG14yhJmkEoyMvKCDdL5z5DUZU68qw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyD3hoRiUAhvengLtPDMS1zRJTjcIT3OUZIATQgeGHaq6pkCLs1
	xun/YNXMolPBVTPL1mQYuXpgaPO8Aepd2orc3oXpbsCwdf5aZrQuGL9cXlBrI16c+CN0OvYVj46
	c
X-Gm-Gg: ASbGnctb+LVNTwXpX5NGL9tx/CVLehgakRhBPSGZ5+THwjwjyY2cEaXLcvdWR/wDgnC
	Wa7Y2TaCIKoH7v5je8r0dDRgqRnuHkR8j3gm+SHV0NzrVZAfNno26Hw4t1Is/eWL5grmbnvR+sv
	O7neMIENTQYvkN8ki9IAMBjbvcnQYy5ckBio919rx4LNWb5mWt3meq9xRbhkxRB6lepq2v5VJqP
	LxKTds+BiWLBk/Yh439GUqitCnz0rxlnkRX4gWiNrKXnIwE+/f+48kQaOnbDQrnlT8Gr1HI9HDd
	/FCRx71F/hHp+O/1ZspG5XZKXAEyQL0FrI57TO+9uDq4afhMlzhPcswX76Pc2P/9MuOZytizvnw
	hZh2XoA==
X-Google-Smtp-Source: AGHT+IEzVK5LsPCPJLOxGzZJMLs0Hpz7cAwlexEXo204aa6yKZYCWEHtDLdFcGmAFiv30Ov47TIhNg==
X-Received: by 2002:a17:902:f693:b0:21d:3bd7:afdd with SMTP id d9443c01a7336-225e0868050mr111601535ad.0.1742115001911;
        Sun, 16 Mar 2025 01:50:01 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539ed069sm3896109a91.17.2025.03.16.01.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Mar 2025 01:50:01 -0700 (PDT)
Date: Sun, 16 Mar 2025 17:49:51 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/3] io-uring/cmd: add iou_vec field for
 io_uring_cmd
Message-ID: <Z9aQr9iUJecNdPQ4@sidongui-MacBookPro.local>
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
 <20250315172319.16770-2-sidong.yang@furiosa.ai>
 <da0445a9-1fb4-4b75-b939-b38ce976205f@gmail.com>
 <Z9aFgKTUmcx-YCMf@sidongui-MacBookPro.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9aFgKTUmcx-YCMf@sidongui-MacBookPro.local>

On Sun, Mar 16, 2025 at 05:02:19PM +0900, Sidong Yang wrote:
> On Sun, Mar 16, 2025 at 07:24:32AM +0000, Pavel Begunkov wrote:
> > On 3/15/25 17:23, Sidong Yang wrote:
> > > This patch adds iou_vec field for io_uring_cmd. Also it needs to be
> > > cleanup for cache. It could be used in uring cmd api that imports
> > > multiple fixed buffers.
> > 
> > Sidong, I think you accidentially erased my authorship over the
> > patch. The only difference I see is that you rebased it and dropped
> > prep patches by placing iou_vec into struct io_uring_cmd_data. And
> > the prep patch was mandatory, once something is exported there is
> > a good chance it gets [ab]used, and iou_vec is not ready for it.
> 
> Yes, First I thought it's not mandatory for this function. But it seems that
> it's needed. I see that your patch hides all fields in io_uring_cmd_data but
> op_data needed to be accessable for btrfs cmd. And I'll take a look for the
> code referencing sqes in io_uring_cmd_data. Let me add the commit for next
> version v4.

I've just realized that your commit don't need to be modified. It's okay to
cast async_data to io_uring_cmd_data. 

Thanks,
Sidong
> 
> Thanks,
> Sidong
> 
> > 
> > 
> > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > ---
> > >   include/linux/io_uring/cmd.h |  1 +
> > >   io_uring/io_uring.c          |  2 +-
> > >   io_uring/opdef.c             |  1 +
> > >   io_uring/uring_cmd.c         | 20 ++++++++++++++++++++
> > >   io_uring/uring_cmd.h         |  3 +++
> > >   5 files changed, 26 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > index 598cacda4aa3..74b9f0aec229 100644
> > > --- a/include/linux/io_uring/cmd.h
> > > +++ b/include/linux/io_uring/cmd.h
> > > @@ -22,6 +22,7 @@ struct io_uring_cmd {
> > >   struct io_uring_cmd_data {
> > >   	void			*op_data;
> > >   	struct io_uring_sqe	sqes[2];
> > > +	struct iou_vec		iou_vec;
> > >   };
> > >   static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
> > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > index 5ff30a7092ed..55334fa53abf 100644
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -289,7 +289,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
> > >   	io_alloc_cache_free(&ctx->apoll_cache, kfree);
> > >   	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
> > >   	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
> > > -	io_alloc_cache_free(&ctx->uring_cache, kfree);
> > > +	io_alloc_cache_free(&ctx->uring_cache, io_cmd_cache_free);
> > >   	io_alloc_cache_free(&ctx->msg_cache, kfree);
> > >   	io_futex_cache_free(ctx);
> > >   	io_rsrc_cache_free(ctx);
> > > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > > index 7fd173197b1e..e275180c2077 100644
> > > --- a/io_uring/opdef.c
> > > +++ b/io_uring/opdef.c
> > > @@ -755,6 +755,7 @@ const struct io_cold_def io_cold_defs[] = {
> > >   	},
> > >   	[IORING_OP_URING_CMD] = {
> > >   		.name			= "URING_CMD",
> > > +		.cleanup		= io_uring_cmd_cleanup,
> > >   	},
> > >   	[IORING_OP_SEND_ZC] = {
> > >   		.name			= "SEND_ZC",
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index de39b602aa82..315c603cfdd4 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -28,6 +28,13 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
> > >   	if (issue_flags & IO_URING_F_UNLOCKED)
> > >   		return;
> > > +
> > > +	req->flags &= ~REQ_F_NEED_CLEANUP;
> > > +
> > > +	io_alloc_cache_vec_kasan(&cache->iou_vec);
> > > +	if (cache->iou_vec.nr > IO_VEC_CACHE_SOFT_CAP)
> > > +		io_vec_free(&cache->iou_vec);
> > > +
> > >   	if (io_alloc_cache_put(&req->ctx->uring_cache, cache)) {
> > >   		ioucmd->sqe = NULL;
> > >   		req->async_data = NULL;
> > > @@ -35,6 +42,11 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
> > >   	}
> > >   }
> > > +void io_uring_cmd_cleanup(struct io_kiocb *req)
> > > +{
> > > +	io_req_uring_cleanup(req, 0);
> > > +}
> > > +
> > >   bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> > >   				   struct io_uring_task *tctx, bool cancel_all)
> > >   {
> > > @@ -339,3 +351,11 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> > >   }
> > >   EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
> > >   #endif
> > > +
> > > +void io_cmd_cache_free(const void *entry)
> > > +{
> > > +	struct io_uring_cmd_data *cache = (struct io_uring_cmd_data *)entry;
> > > +
> > > +	io_vec_free(&cache->iou_vec);
> > > +	kfree(cache);
> > > +}
> > > diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
> > > index f6837ee0955b..d2b9c1522e22 100644
> > > --- a/io_uring/uring_cmd.h
> > > +++ b/io_uring/uring_cmd.h
> > > @@ -1,7 +1,10 @@
> > >   // SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/io_uring_types.h>
> > >   int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
> > >   int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> > > +void io_uring_cmd_cleanup(struct io_kiocb *req);
> > >   bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> > >   				   struct io_uring_task *tctx, bool cancel_all);
> > > +void io_cmd_cache_free(const void *entry);
> > 
> > -- 
> > Pavel Begunkov
> > 

