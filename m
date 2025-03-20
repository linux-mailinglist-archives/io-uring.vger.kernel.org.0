Return-Path: <io-uring+bounces-7153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF6CA6AAE8
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 17:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABECC3B94C7
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 16:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932E71E9B0C;
	Thu, 20 Mar 2025 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="AqttIiog"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED421E3DC4
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742487581; cv=none; b=Mq0mnUw2nOUf0zz5B9bOd8+W/DEIcssjoGpPAEr9nbTY48oHBlbIkeeD2gf3uu2KNsvuQbFX/pR8D/SpzwyM7UeSuA4q49sJ4E7EFNXTLKN5TodT1jjHtp9s8nnVlm208OfneXvy5dP34sUpBS5jyw0ie8FvTR+jfU2XOrI9XkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742487581; c=relaxed/simple;
	bh=qBJxg1shh5xIWb/EGEp/yZw666gWV1SYFdnG1TDjCyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQclUhGaMCiENkMVezUToCrZD5Y+2fWMFT9jiurgmoDcfsmmJn6hc3oSjJlTThpo8TOHVvRETCMvAwydNWFDGnqFWbiBRkRKSVCOSzzfAGvSL0P6s68LMtTMZLEStuCf8L/RxmHSPaD/mrYJ5dTLGzOIDlR79CPc3oxRR69o7nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=AqttIiog; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-224191d92e4so20869675ad.3
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 09:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742487579; x=1743092379; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E1EkxBQfCDmnx+n40Vp0lQXT3U/EpuuEwT1O/tsDLy8=;
        b=AqttIiogKzRrEVtvUGN2K9Xsux6kBQ2eXR67MVBG4b3bnlxxH0x9ujI7g+xf0dDygc
         /77HOQjrRowrjmnxrsM31rVDKtp8XbnQuZXKey0UadV+fSD9oIs2KIBVncoerm3xuqUA
         JMMuYK4WfcieUGuLUPB3PYzowcUH0cB7ZzNwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742487579; x=1743092379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1EkxBQfCDmnx+n40Vp0lQXT3U/EpuuEwT1O/tsDLy8=;
        b=QOskq3brlUPU8YCTqrdHP3bV2WfV9FWcsWi36UHLVjW9ZXOCzLsI/G6tAUchXG02i5
         LkaqMrmA+y/GqAfjwq08UlUcf/YKBp6G5NJrjKtCfkcN3BKf0P1tmNha5HQU9S6hQCo5
         qerj1AgLjSYCwhm3TmT+gb8sf2mdnb7UFEFPuQt71b5qjBA9nEUZ/DzKSl3KYzd3eE0d
         06nhbkImwsemnfMd5Yibw1AGJyJ71B17G+u5ohYhXL3O9B83raEji1nAKkOtV/p38sW1
         /5T6OZqll2enwzNpYLdYrtVx1FB/bM6VEnql+27MB1XEkYAWX+dNLUIdROv1j5jIrx5n
         4aog==
X-Forwarded-Encrypted: i=1; AJvYcCWi7k4dtXv7oErg2JB8fkxZrqSRGNKEt7OUQ+mWJg92ef+cxx9s0izBMx5Ok056tGmSEK/t2HfJhg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl0F+viebqo1J/aaaGLDsxzxZpkF4h4NzDDTx2S4Ze0zBYHyaV
	PbMCt8dGZSBjCxlkCYkxbOVJZU78S8SHVnEGH+YHcbzB6X9dT4/39xAfUpYEiJ0=
X-Gm-Gg: ASbGncuQ6muktGSwr5mFnbNjIvSTK/6cjfpMK3hYR37EaUkaZBDSZog1PcR+FXQDDkc
	8EjkittlMud2CJWBj5cEouC0Z0WSQRwUL389Fbz4jCPx3/V9G4LJo10M1uqOlmmYjIux78ZNzV5
	7gxZ2MhmL1K8dhfsHTU5yCKQ8tHiF3cFDPo27ZEwGaVmE97bTrTBQ14Cm9ju/yIubTgGEXsMvzv
	a+ART8jAAMQLv/gZX/iFf1Z6GOfIIRy8AsX8egC2t0nbc8FAroYfKj8tyL6PJ6gGF+wm3L/v4Q/
	xe8Hx4fnmjZd6tvm9K6QFO9hBZFbGF1BW3W6NW6Djb2SibYbylAwAy6DCFllQFwyuGIS/XkgQxv
	h
X-Google-Smtp-Source: AGHT+IHkoC8+a/PI1OgLEI6QOhiYG1kobquqNfEOAiiqzCU00hktNWB4i+b5NArdRabJhomNAfkeIg==
X-Received: by 2002:a17:903:2301:b0:220:f151:b668 with SMTP id d9443c01a7336-22780d9597dmr51485ad.20.1742487579151;
        Thu, 20 Mar 2025 09:19:39 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbe766sm137642715ad.184.2025.03.20.09.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 09:19:38 -0700 (PDT)
Date: Fri, 21 Mar 2025 01:19:34 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v5 5/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
Message-ID: <Z9xAFpS-9CNF3Jiv@sidongui-MacBookPro.local>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <20250319061251.21452-6-sidong.yang@furiosa.ai>
 <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>

On Thu, Mar 20, 2025 at 12:01:42PM +0000, Pavel Begunkov wrote:
> On 3/19/25 06:12, Sidong Yang wrote:
> > This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> > with uring cmd, it uses import_iovec without supporting fixed buffer.
> > btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> > IORING_URING_CMD_FIXED.
> 
> Looks fine to me. The only comment, it appears btrfs silently ignored
> IORING_URING_CMD_FIXED before, so theoretically it changes the uapi.
> It should be fine, but maybe we should sneak in and backport a patch
> refusing the flag for older kernels?

I think it's okay to leave the old version as it is. Making it to refuse
the flag could break user application.

Thanks,
Sidong

> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >   fs/btrfs/ioctl.c | 34 +++++++++++++++++++++++++---------
> >   1 file changed, 25 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 6c18bad53cd3..e5b4af41ca6b 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -4802,7 +4802,29 @@ struct btrfs_uring_encoded_data {
> >   	struct iov_iter iter;
> >   };
> > -static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue_flags)
> > +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
> > +				    unsigned int issue_flags, int rw)
> > +{
> > +	struct btrfs_uring_encoded_data *data =
> > +		io_uring_cmd_get_async_data(cmd)->op_data;
> > +	int ret;
> > +
> > +	if (cmd->flags & IORING_URING_CMD_FIXED) {
> > +		data->iov = NULL;
> > +		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
> > +						    data->args.iovcnt, rw,
> > +						    &data->iter, issue_flags);
> > +	} else {
> > +		data->iov = data->iovstack;
> > +		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
> > +				   ARRAY_SIZE(data->iovstack), &data->iov,
> > +				   &data->iter);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> > +				    unsigned int issue_flags)
> >   {
> >   	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
> >   	size_t copy_end;
> > @@ -4874,10 +4896,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
> >   			goto out_acct;
> >   		}
> > -		data->iov = data->iovstack;
> > -		ret = import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
> > -				   ARRAY_SIZE(data->iovstack), &data->iov,
> > -				   &data->iter);
> > +		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_DEST);
> >   		if (ret < 0)
> >   			goto out_acct;
> > @@ -5022,10 +5041,7 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
> >   		if (data->args.len > data->args.unencoded_len - data->args.unencoded_offset)
> >   			goto out_acct;
> > -		data->iov = data->iovstack;
> > -		ret = import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
> > -				   ARRAY_SIZE(data->iovstack), &data->iov,
> > -				   &data->iter);
> > +		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_SOURCE);
> >   		if (ret < 0)
> >   			goto out_acct;
> 
> -- 
> Pavel Begunkov
> 

