Return-Path: <io-uring+bounces-7101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 969EFA665D2
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 03:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15BA51883F5E
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 01:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2D114EC60;
	Tue, 18 Mar 2025 01:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="DDEOx4oT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A540149C7B
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 01:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742263144; cv=none; b=P8iSjGmo2O0hgXdbQ9PEoz67g7kwYet/oGVlk4QejVmxSC079tU9kjqiJ4Fq3vUe4avpiSWLepOqqo9v/h8V/RCO0tIn0aU5jY2PNZc2lEUObJh63OEkqlWcVq8U+gvxpZRyTos5w1njmYEFnDXFMOOgCi/05pPSRZ2K3jYQB4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742263144; c=relaxed/simple;
	bh=L1Ne+QTLuSdegNnkSjDRJuIzUEEggu+Dwn3f9jsYy+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3jWRr3r2RCjz6nH2cWB/qk8LWWnubVTlJJxN6hwdAURb4dA3HLXZTBBXMEZSokyW1tf/D4AMJwgUCrHFQCW+Y4REsN07kAtK8Nf2hp72mRNGOV+WTI4sXKlgz0BnzYyPeoCa1VpsR28uO86BpG59KC3F8BS34sfGPKJoMWP45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=DDEOx4oT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224019ad9edso46268545ad.1
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 18:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742263142; x=1742867942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yOwruOmPjgZz22CNw0HJ3t+DF5i9C0EpnBm3V/TK2zc=;
        b=DDEOx4oTrDtwtJdbXQOiMaw/Xiledcg/Op42tkWZvxSEDTTvnI7HKFRHD0vz9JmZe9
         5rRDFh1n2N8RDaXMucjfPw6CEkGKVpxgNZuAQrMEW/ls85HUWi6B5/V6FRJYYNImxGIy
         G6zI2hErgZq3i1v6ygEA41/dZw5P8AcIfec9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742263142; x=1742867942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOwruOmPjgZz22CNw0HJ3t+DF5i9C0EpnBm3V/TK2zc=;
        b=acqXT5l5d34/8m97Q3DiL42js4xTkLlHdwZhUSW/NkriTbXy6fFKXM2ctGGHr5c3n9
         WOCi0eU8oTHML/n9QB/7sdFkEZhjnhoH1CyQiC6UZYyuE3ljbbBBNWYNPqgw0Yqt33al
         muh8Mt1IAY/TVuVswF5kHSqiVsM97BFyBaHipwCxkUh8aHnzH6+SqzvyugC7bvzq0W3x
         PA2ynSzyXhk8psUGDN/7WMzekpxidn8JZTBGdz2KrRiOLo2KNX6O1yUu/32ZmUMsZfDD
         /esxFBXqEb56q3cFLjcgPycNxYMuuHPJbk6auoB8Qxn09f4ALSqGX7YG8r8BZVkt0F+R
         MKbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPMKWh1X0e2mOsqs6TrM4Zj1qP+l0XFiqPzABhZagsiMfiLZFVRrfNt86cx5UBSKrQOXnN22L6jg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu5V1+K4uxELcbJR73e8J4UB7ltKpXQwut4wVL/ju8cJ0XNr6p
	81XfEF3Ety7j9J/iFojBlGVbNRQdtXJtYGxmljFNfG0JXbmM/FW7Kw2iNQsMfEg=
X-Gm-Gg: ASbGncuQ6yduCs/jhd5kNfkGv3uWm6NH4mwCgd4ir1ehRi4oVf+AgdFvtYYFM/mV7dW
	bhb6NkmBll994zbalcrKqdJ0z5j0m867xeK+M70Zc9VThoX7q0Q8dgTr8w5x0t0QDvo1ff+xCVq
	UDqENihY9S11jLIwp+BfRXCtDqaDKKR9STIcDcGvyMYo6Z8859Bqf5E7iqvkVvKQqv9sV+iDDuk
	60Hni87ucPefmD2JdrSHcVKFUdqOPHmN47nrtZwVK8CE3v2aJ20iwolHH19PuhCbkyp77I8IBt/
	Sf9dHKxu0nt778KVr/4u/qUPPL5/6ipv56Fu5nk6HNcb80mN0nv4yaCl0fqreCwLE7yCcnnZeMO
	rE8LQxA==
X-Google-Smtp-Source: AGHT+IHqhx0/CqW3BpT7+MPNBrTrcJBjwwRUne8O/7u2qtvmr8uSD5puhwybpej9PasKSNdyCQO0rg==
X-Received: by 2002:a05:6a00:3d55:b0:736:ab48:18f0 with SMTP id d2e1a72fcca58-73757205e9cmr1957081b3a.1.1742263142384;
        Mon, 17 Mar 2025 18:59:02 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695b88sm8296766b3a.152.2025.03.17.18.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 18:59:01 -0700 (PDT)
Date: Tue, 18 Mar 2025 10:58:57 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
Message-ID: <Z9jTYWAvcWJNyaIN@sidongui-MacBookPro.local>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
 <20250317135742.4331-5-sidong.yang@furiosa.ai>
 <3a883e1e-d822-4c89-a7b0-f8802b8cc261@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a883e1e-d822-4c89-a7b0-f8802b8cc261@kernel.dk>

On Mon, Mar 17, 2025 at 09:40:05AM -0600, Jens Axboe wrote:
> On 3/17/25 7:57 AM, Sidong Yang wrote:
> > This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> > with uring cmd, it uses import_iovec without supporting fixed buffer.
> > btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> > IORING_URING_CMD_FIXED.
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >  fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++--------
> >  1 file changed, 24 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 6c18bad53cd3..a7b52fd99059 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -4802,6 +4802,28 @@ struct btrfs_uring_encoded_data {
> >  	struct iov_iter iter;
> >  };
> >  
> > +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
> > +				    unsigned int issue_flags, int rw)
> > +{
> > +	struct btrfs_uring_encoded_data *data =
> > +		io_uring_cmd_get_async_data(cmd)->op_data;
> > +	int ret;
> > +
> > +	if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
> > +		data->iov = NULL;
> > +		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
> > +						    data->args.iovcnt,
> > +						    ITER_DEST, issue_flags,
> > +						    &data->iter);
> > +	} else {
> > +		data->iov = data->iovstack;
> > +		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
> > +				   ARRAY_SIZE(data->iovstack), &data->iov,
> > +				   &data->iter);
> > +	}
> > +	return ret;
> > +}
> 
> How can 'cmd' be NULL here?

It seems that there is no checkes for 'cmd' before and it works same as before.
But I think it's better to add a check in function start for safety.

> 
> 
> -- 
> Jens Axboe
> 

