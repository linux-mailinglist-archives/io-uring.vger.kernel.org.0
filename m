Return-Path: <io-uring+bounces-8943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 302BDB229AF
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 16:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 343006E0368
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 13:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CDB283142;
	Tue, 12 Aug 2025 13:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="m06qHcBU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EEA283FFF
	for <io-uring@vger.kernel.org>; Tue, 12 Aug 2025 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755007002; cv=none; b=jFBGRYDW0ct6C8JljMuaSq6cnoVjymbqZnmMFLhtoVmqU9d82SQuWbDjXSQqYLsusm5CX5nN2URaKauvzzKgLNWqfhOW7Fjw995wASPEOMR6RbVVg65PH2nWXEtK7pqU2OBJf7SmRTN5hYoA2VMkgsd14k1zCpEIDT/TI2sLy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755007002; c=relaxed/simple;
	bh=ifkzomFcpe8Uk7XzdkvoUVDkTw4hMSjtDB5FJ9Qmx5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4fQaypqh5KensfluWDnZxNzJLqD8FGMdOEE1t0GT588PLT1Guj6LUOSRXEv1DoyaaIPmP4rV+dQ/NVXlwB+dKsU5dOJM4cYqkRVCtGTCrfVMLDpeXZVPsJe0Q6djvj4BdEKOkAcrxmCeV+MgWw0U52HPf3Khzjm056KJYKcwGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=m06qHcBU; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73c17c770a7so6900125b3a.2
        for <io-uring@vger.kernel.org>; Tue, 12 Aug 2025 06:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1755007000; x=1755611800; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=muKLwWTItd7PcxJ11Sn7699T3U4KoLGnLzfODwqe2/A=;
        b=m06qHcBUPUkPApxzhyazxvG8qlGhCQXNCm8OqVhme11sSm3VYkdanpMEazkf0x/ONt
         lrliVE8mKI9CA0xnbcTdompF0cSyBWcsESixCTosasyddRYO7Njl4NRU8sJ2vt7Vdz3S
         FOjNNQvoPoiguHclIO0uvbu2ufVh6YxIgDTUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755007000; x=1755611800;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=muKLwWTItd7PcxJ11Sn7699T3U4KoLGnLzfODwqe2/A=;
        b=Bcoy9OHyYV/butfECaggJoJHxbnWC3XUS8u9VqBl2Cp02BHWmxjEvc+AHAy629ENJQ
         aw0mlocZxZ3QRfERdhWrlO2ZgCEeHFiDg8xgWyoHcnVw87l2IErXQtchkTnPHXt4nrrU
         /Di4gxtTLemTNtW8a98GawRT16vSgrZcOBy5HhtY396wGGzPudE3aZUYHG4jD2Hnr22F
         gLbulTRxQhhLeNnSk76HIIR6cTljAPzyeZrNIqbAKkF46Py+aUmdVHWsrRaYvNn6aa1s
         FuDg7DfRhzgHPymMSrdo0YoSumppSIR3mfCsDPcqDU0bpXmjD8Allr+otzVyQ8AiWxe4
         ssTg==
X-Forwarded-Encrypted: i=1; AJvYcCWm442vBREtL7PYn+Ci7c2IZ+Wm9l4kNIuYpnhDRAb6rp3R0/5d61zKNOAfvgSiYsWoibhpnNnxog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6DoEpPhBQ16yy7wNYi5Gg30fhjOcuISvxYB7atNmZLnmS0mJd
	SjAtNBn+Sx8HkEnwIXx/fFoIvMO4ZC6BrtSv6mNdTdHbczYn+MRVYnFi8vVsGUfhqTc=
X-Gm-Gg: ASbGnctC0tDE4ZTjofl5qpvdc9QmYPi37kD2aw+UEgerkC3ZB+BLLFLhjuovKu/fUJm
	xUSBdep/geqYvmhANqWjCasXwq5scyYmcJVMcltdkUhgtmwMSEV3skW3QeAXQh/sNuS9SzfuH2B
	3asMFNrPoHKYsjtvOs+cdu5Ef4YkESDx82ZJXBc3OCZLjs/oBMrkRQGJVFLM9mxA8WoX0knRuCM
	2tU+7eE52YZIOKCh18KoHodglzYAzJObwIXl5PkJ2qznujKVClfFI25JRPzznWD2Q5tpRy6vhyQ
	IbaxYH+pSmRwFoDlnoRxdWNjNVPo62mR8BZ7L+KdW4C9lnEHUD2KyEKQWUXW7dXX3Ee/il8+BwU
	HyG7sK7g7ZGl5uI9tmPRBMSDFgNNC33i4SBVabgL7wc3fEagdhdhpog==
X-Google-Smtp-Source: AGHT+IF9oN/gDVZZuBafNymjfs7XlnC1Pfdu0olKj+9cEw7XmHBwFYKpaec3jtfFbtVwLA2vd55SPA==
X-Received: by 2002:a05:6a20:3d8b:b0:240:2234:6860 with SMTP id adf61e73a8af0-240551e9963mr23615243637.32.1755006999905;
        Tue, 12 Aug 2025 06:56:39 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7d86f7sm25362441a12.24.2025.08.12.06.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 06:56:39 -0700 (PDT)
Date: Tue, 12 Aug 2025 22:56:30 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Benno Lossin <lossin@kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJtIDlSBLJSRxBwQ@sidongui-MacBookPro.local>
References: <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
 <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
 <8416C381-A654-41D4-A731-323CEDE58BB1@collabora.com>
 <aJoDTDwkoj50eKBX@sidongui-MacBookPro.local>
 <DC0B7TRVRFMY.29LDRJOU3WJY2@kernel.org>
 <aJsxUpWXu6phEMLR@sidongui-MacBookPro.local>
 <9A6E941F-3F40-40C5-A900-4C22B27D1982@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9A6E941F-3F40-40C5-A900-4C22B27D1982@collabora.com>

On Tue, Aug 12, 2025 at 09:43:56AM -0300, Daniel Almeida wrote:
> 
> 
> > On 12 Aug 2025, at 09:19, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > On Tue, Aug 12, 2025 at 10:34:56AM +0200, Benno Lossin wrote:
> >> On Mon Aug 11, 2025 at 4:50 PM CEST, Sidong Yang wrote:
> >>> On Mon, Aug 11, 2025 at 09:44:22AM -0300, Daniel Almeida wrote:
> >>>>> There is `uring_cmd` callback in `file_operation` at c side. `Pin<&mut IoUringCmd>`
> >>>>> would be create in the callback function. But the callback function could be
> >>>>> called repeatedly with same `io_uring_cmd` instance as far as I know.
> >>>>> 
> >>>>> But in c side, there is initialization step `io_uring_cmd_prep()`.
> >>>>> How about fill zero pdu in `io_uring_cmd_prep()`? And we could assign a byte
> >>>>> as flag in pdu for checking initialized also we should provide 31 bytes except
> >>>>> a byte for the flag.
> >>>>> 
> >>>> 
> >>>> That was a follow-up question of mine. Can´t we enforce zero-initialization
> >>>> in C to get rid of this MaybeUninit? Uninitialized data is just bad in general.
> >>>> 
> >>>> Hopefully this can be done as you've described above, but I don't want to over
> >>>> extend my opinion on something I know nothing about.
> >>> 
> >>> I need to add a commit that initialize pdu in prep step in next version. 
> >>> I'd like to get a comment from io_uring maintainer Jens. Thanks.
> >>> 
> >>> If we could initialize (filling zero) in prep step, How about casting issue?
> >>> Driver still needs to cast array to its private struct in unsafe?
> >> 
> >> We still would have the casting issue.
> >> 
> >> Can't we do the following:
> >> 
> >> * Add a new associated type to `MiscDevice` called `IoUringPdu` that
> >>  has to implement `Default` and have a size of at most 32 bytes.
> >> * make `IoUringCmd` generic
> >> * make `MiscDevice::uring_cmd` take `Pin<&mut IoUringCmd<Self::IoUringPdu>>`
> >> * initialize the private data to be `IoUringPdu::default()` when we
> >>  create the `IoUringCmd` object.
> > 
> > `uring_cmd` could be called multiple times. So we can't initialize
> > in that time. I don't understand that how can we cast [u8; 32] to
> > `IoUringPdu` safely. It seems that casting can't help to use unsafe.
> > I think best way is that just return zerod `&mut [u8; 32]` and
> > each driver implements safe serde logic for its private data. 
> > 
> 
> Again, can´t we use FromBytes for this?

Agreed, we need FromBytes for read_pdu and AsBytes for write_pdu. I'll reference
dma code for next version.

Thanks,
Sidong
> 
> 

