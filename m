Return-Path: <io-uring+bounces-7108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44982A66CF7
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 08:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D224C17CA6B
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C321C1E8356;
	Tue, 18 Mar 2025 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="J/7qt6eg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329A51DED45
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 07:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742284555; cv=none; b=U1cZVKWCDvTQUp49GhasTzBkO3YRJfoG/1QQbxpq/QqkkyAIKNwXmbK+WI9CldNNVg8NVh33eqCRrR8nhrxoiiwKnW2rqrUf1budyT7qExj8D7B6SGovufdOXs3xn50OK365uyOo4BRWGQeDudPIoFyLzEsrtFXVerEk51nh/PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742284555; c=relaxed/simple;
	bh=N+vhNC0jMyh202u4Nzngi+/YScqdgkuR1GpsqEXNxTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RC+nKjvtnyMVJTXLk11tsRV/GEIl1Ny/H50GnDUrB+ttm+VRMqcu7RGaf2nc04Kk9rH6WNRhRTpKCNI5ksuFOCnJ1rwJ0JY4enbhqepxN5W0VQDbl9u0oYxKBZXR5qvZgAmJwx2ObLBzzbuT2EIv7xG+UcA5asezdWK4KVrSUkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=J/7qt6eg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225df540edcso70801205ad.0
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 00:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742284553; x=1742889353; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AWqw/1YNqpsUiTasqbG4aqWj2NMVBNVnLiGA9t51nRU=;
        b=J/7qt6egEm8xpLU14Nfwpl4aCF+YBSLKG2siRAZg+zTk9E6g8PpB0hbAyrNJjDJjlE
         WFTRj0nXHIDOBY6t37Qb6IQgVk5QIBxDbSv9JIUqp+g2EWQbRhWf8UK1+vI95U2QC7x7
         f4fWS1VkpAqm0veTij9zd1ghlaaSu/R0ont/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742284553; x=1742889353;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWqw/1YNqpsUiTasqbG4aqWj2NMVBNVnLiGA9t51nRU=;
        b=rQrdX9n4U0yr0WXBue/smiXeJk0CED6polpg7idYqfF37zb03yCGtVZRzPS7ErbK9D
         D3F0teqfjFTtzyj/2p8n8cgiNICwCZ7ZptSYnH0EBivjuoH6Gpbg6KWRXGjComs0pvJK
         CzKsnX+xaSWtaoLb3FX8bI+I28u++2KkODkh0WsJtPEbFm6vpFVgqe6cZ48B8uxbQqkU
         Xa5nq/m///rqHBOnrw2odHxZfOZ0doP63ST6p7IzjkHDVK0DNZTRuPDGdLjbKbP+4DuH
         MYNSBRD6rrdeUh/YZkPHYVXlW4Jps7sqfV+qySMmpqADwujaf7G76rupfL6UE6bY5v9z
         3wNw==
X-Forwarded-Encrypted: i=1; AJvYcCU7QTjDk0wcHtWOUz8mrJFdcCv3hOC3ADNWQUCv4m9sazXUV41/UThZf7tc8kv+aOTnqBD1nWhMJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwH1AdUqiZrh2gtlJiONFdkOa9UeBIlRMBOAGVqC+HIsUZDzh2x
	ARABiR5xWB45gn7Jm+XRXofiGXykDCrM6cg4v6Vch0UkIB/giLUgEZtrBtB4dLE=
X-Gm-Gg: ASbGnctKRdxlrRw/BqnYdBu9Kd/a2erZboqV2xGEdiNdzxgppkhdT2UHWCPpZn49Y0Z
	/GHwEwZBpQZIPuqWEfScqEKlpsyAkGk7KrjAEZBwey8+iGaishomU46bFtWLXtxXwucxzBAEFoJ
	kDKfKWhpUbr4RSujBArFcWr+bUGZQNJ/INc5q2/+7oxofr0lIXXL2hx6Lrf4gxeKq83NyR7vqeM
	o0IMrLeCSNsZgycgF9FHnWqB8/9gfOcv5G5eBNKoPFU6Di6a8wwqPfGHLC1gEahe/izxcVhO0r7
	kcf4T4HSpHYuj6NZ0rTqMzU9rk4uJhGi1CmIVubQq7HZhlCQraH3HUCmcgZavELeuVmFowCYFwE
	D
X-Google-Smtp-Source: AGHT+IGLSujM6CyWqFOh57z55RWygpWHWUeBFLDSwNoV+Z1DhMnmwP9sY/TJGMmFDBV3BlyR8M6DEQ==
X-Received: by 2002:a05:6a00:4fc3:b0:736:b3cb:5db with SMTP id d2e1a72fcca58-73757a53663mr3191488b3a.11.1742284553335;
        Tue, 18 Mar 2025 00:55:53 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371169c3desm8846112b3a.155.2025.03.18.00.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 00:55:52 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:55:43 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
Message-ID: <Z9km_8ai2zq86JKI@sidongui-MacBookPro.local>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
 <20250317135742.4331-5-sidong.yang@furiosa.ai>
 <3a883e1e-d822-4c89-a7b0-f8802b8cc261@kernel.dk>
 <Z9jTYWAvcWJNyaIN@sidongui-MacBookPro.local>
 <566c700c-d3d5-4899-8de1-87092e76310c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566c700c-d3d5-4899-8de1-87092e76310c@gmail.com>

On Tue, Mar 18, 2025 at 07:25:51AM +0000, Pavel Begunkov wrote:
> On 3/18/25 01:58, Sidong Yang wrote:
> > On Mon, Mar 17, 2025 at 09:40:05AM -0600, Jens Axboe wrote:
> > > On 3/17/25 7:57 AM, Sidong Yang wrote:
> > > > This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> > > > with uring cmd, it uses import_iovec without supporting fixed buffer.
> > > > btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> > > > IORING_URING_CMD_FIXED.
> > > > 
> > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > ---
> > > >   fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++--------
> > > >   1 file changed, 24 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > > index 6c18bad53cd3..a7b52fd99059 100644
> > > > --- a/fs/btrfs/ioctl.c
> > > > +++ b/fs/btrfs/ioctl.c
> > > > @@ -4802,6 +4802,28 @@ struct btrfs_uring_encoded_data {
> > > >   	struct iov_iter iter;
> > > >   };
> > > > +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
> > > > +				    unsigned int issue_flags, int rw)
> > > > +{
> > > > +	struct btrfs_uring_encoded_data *data =
> > > > +		io_uring_cmd_get_async_data(cmd)->op_data;
> > > > +	int ret;
> > > > +
> > > > +	if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
> > > > +		data->iov = NULL;
> > > > +		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
> > > > +						    data->args.iovcnt,
> > > > +						    ITER_DEST, issue_flags,
> > > > +						    &data->iter);
> > > > +	} else {
> > > > +		data->iov = data->iovstack;
> > > > +		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
> > > > +				   ARRAY_SIZE(data->iovstack), &data->iov,
> > > > +				   &data->iter);
> > > > +	}
> > > > +	return ret;
> > > > +}
> > > 
> > > How can 'cmd' be NULL here?
> > 
> > It seems that there is no checkes for 'cmd' before and it works same as before.
> > But I think it's better to add a check in function start for safety.
> 
> The check goes two lines after you already dereferenced it, and it
> seems to be called from io_uring cmd specific code. The null check
> only adds to confusion.

You mean 'cmd' already dereferenced for async_data. Is it okay to just delete code
checking 'cmd' like below?

if (cmd->flags & IORING_URING_CMD_FIXED) {

Thanks,
Sidong

> 
> -- 
> Pavel Begunkov
> 

