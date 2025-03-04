Return-Path: <io-uring+bounces-6923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 721E9A4D9BC
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 11:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A081A16D174
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 10:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9471FDA90;
	Tue,  4 Mar 2025 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cr9dICnT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A221FDA8E
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082640; cv=none; b=UMur02mAEjXqO8F4ONSYZeNJDo0l9dh50+MKZIe8c/IGlEn6tthU7bce9UiWASiu/5P3lMCdkh82aSuf7e2GsaEZlUnGYztJrhr/9p/60snmt37QaNimhGrBEIT6+PmoM+a+gyQgm30sTIqOIYOz2F4nRKbPP6NiWJe1kS37FEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082640; c=relaxed/simple;
	bh=CcUFzC3BkGTwXeZWeXpJeyXnpY/fjUaOoPZ4Sr5x6MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQq5dRLbWaPN965VFliqKSyg8/At+a4SJOmVS3Aed1zNp/qJQBm4kSTqBpiaf7vwh5DDDlzWJzUUlG96MtqvSWm71elpM/KWkG8dwXR5OHDrXS4VFsJ9yC5ZlCCdwv/NtDNzQ287b0yRmGLYrRb0hyjG6WZp29gqMBD1F1oicr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cr9dICnT; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e0573a84fcso7436920a12.2
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 02:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741082637; x=1741687437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gl1F4sbRclYIL/lkDqHBpEh95oSZNjmBBTl8UIi47bw=;
        b=Cr9dICnTGRRrngpIyNkWmt9kfACr2CvfR6O5zCmQpiOIFqwQ5TiLsbpxt2wbS+kUcs
         0gf+DKO2orG183nxuVulAxoSgdNogmynNbc8CKAjHKsI256j+5Xq0OQqllZGgYLX4QUr
         TrRUJo5S/Mmp5qsbZdjsyujr6VNbzcH64wNKhkRkWrAEcPkPk2RMuIbq9RH6waJ/jEgl
         rUGKpQn+pr8x1k4MDUQtdkbeuezhl159ADVQvJk+sWu7xQXzVzvHYHmc/bA3awfJC6rJ
         NMgc4ypf1NZMhiNCAyVzz5buuvzBuriEYuFT2SDS5xDR7VXupF6mFR1ABqxs9b6e/V2V
         xcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741082637; x=1741687437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gl1F4sbRclYIL/lkDqHBpEh95oSZNjmBBTl8UIi47bw=;
        b=M8fcqHNRqlaG1EBIz8BJIMoE2zJYLYOLuER3VMEJsCDbOaIUGZkg48z08Wdk9YPekg
         7oAyGeM2F72Rn0X+6dRxHoTcIJktyJkvJgWSkMMh9ijUtcZ5AlF3MaLThrtOpBhZRi0k
         aKqAacfQgyAuErd11xlhqb+HJ4XFSNXiEBoKj3Vf7I2ZXCOvFsMz+YnR8N4jikeBfbXq
         Lz3LGrSNaRrt+tpSP7Qcp28Vxu1YsmqwwRPSNpnW3faSFkugkD3bFVismhkpo+uAD2xM
         tpAQaEPb56SSybDPGlg3YPKC43YmyhqTTzN5J9KlrqYcG0B9Sjxonn65lZnd1DjPO3eP
         Pd1Q==
X-Gm-Message-State: AOJu0YyO0sjb6duUuM0/noda11ZUQWIO5MqemJqfm9fKNmGnPVhswieM
	s4vbov8oXu8nt1zed2JFwjt4E8A8Zm2IvWGKmflx6kiwZOwTdRQt
X-Gm-Gg: ASbGncvjVh0xd56vaHhCx3kMfU30CtcITd1Lb1qPco8G/0iuo+lfQqeav84/MVJ3fg4
	bI4iCX0ITEkTNeoYoCf+xE3OTPt1ETvnZZ7vQIO/gvi5enf93fqZ8vGdiizGhxqAYgDJVBSNwAn
	UnDyF4Rmx1q/IsE0SlzMKTFggjUdjDGY2J3VSHH6F7auGYVxFelUNjPBFvEVp3L4kIOn8gtDhiy
	QiaibCWBgGo2Pff3D+mERd+G8nTNoVnWrH+pzwv3p5RrSLdDCzKuSlOSy/SmVUYJ+qiCAQudP6L
	kS27ruLFKF3C7ExtBmfeVJaURReruS5u2W/tmuhXP9Ltcqw5LQNIZNLIpMAl3GDVBjN68Lke2vr
	f1Q==
X-Google-Smtp-Source: AGHT+IGFIDKe2jEP4Fx0e5enPDs3De+9hJ6A+AjsBgiU/7kh8Nwv8wm7BE97oCKGjGFEfFoXn1arQQ==
X-Received: by 2002:a17:907:3d92:b0:ac1:e332:b1f5 with SMTP id a640c23a62f3a-ac1e332b482mr571301466b.37.1741082637079;
        Tue, 04 Mar 2025 02:03:57 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:87eb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1e02f9660sm213150266b.71.2025.03.04.02.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 02:03:56 -0800 (PST)
Message-ID: <9a5e3d75-afef-4942-881c-444d35472758@gmail.com>
Date: Tue, 4 Mar 2025 10:05:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] io_uring: add infra for importing vectored reg
 buffers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
 <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/3/25 20:49, Caleb Sander Mateos wrote:
> On Mon, Mar 3, 2025 at 7:51 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
> 
> If I understand correctly, io_import_reg_vec() converts the iovecs to
> bio_vecs in place. If an iovec expands to more than one bio_vec (i.e.
> crosses a folio boundary), wouldn't the bio_vecs overwrite iovecs that
> hadn't been processed yet?

It's handled, obviously, you missed that the vectors are
offset'ed from each other.

> >> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 9b05e614819e..1ec1f5b3e385 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
...
>> +               for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
>> +                       size_t seg_size = min_t(size_t, iov_len,
>> +                                               folio_size - offset);
>> +
>> +                       res_bvec[bvec_idx].bv_page = src_bvec->bv_page;
>> +                       res_bvec[bvec_idx].bv_offset = offset;
>> +                       res_bvec[bvec_idx].bv_len = seg_size;
> 
> Could just increment res_bvec to avoid the variable bvec_idx?

I don't see the benefit.

>> +       for (i = 0; i < nr_iovs; i++)
>> +               max_segs += (iov[i].iov_len >> shift) + 2;
> 
> Sees like this may overestimate a bit. I think something like this
> would give the exact number of segments for each iovec?
> (((u64)iov_base & folio_mask) + iov_len + folio_mask) >> folio_shift

It's overestimated exactly to avoid a beast like this.

-- 
Pavel Begunkov


