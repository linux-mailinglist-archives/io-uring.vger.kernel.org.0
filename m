Return-Path: <io-uring+bounces-8887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19882B1C304
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 11:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39C5627DB9
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 09:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403AC28A41B;
	Wed,  6 Aug 2025 09:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="K80YoHgV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF62028A415
	for <io-uring@vger.kernel.org>; Wed,  6 Aug 2025 09:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754471507; cv=none; b=N2xUKp2T7R9xnKLGMzc4wCaDSq1C/KN4fTkTRzTTYY8EaaMvhl//LhsVRqp7/cdGJ4BLAJiuQePE/JALPBpjrJAjViA0ph4ObDiZZ/n7WNem+ompwjSP3thlAbTY2E1ZfVNLywgms5ZA85jAxd2/gx+p9MWbY3QO6bRXOMy1+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754471507; c=relaxed/simple;
	bh=ZObCFNQv4UMF0xsJTXeG2FT2Dm5Gph+xuZC2Eg7Hb3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/qBNX4h8As4qFOtPYYxcGM8VCguhnB9n306LqMzOA4TV3K85MKupVKEaC+mb2Itio8mVGbkE3IvFKpxerviyF+bzT3dDDCFXvXibNLQi0DqLKuok8R0AZZELZzPCYT2ghebZfcqnOfQD3KyvDtn6Rade9Y+Kkxy1YM/4sfJzC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=K80YoHgV; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23c8f179e1bso63526265ad.1
        for <io-uring@vger.kernel.org>; Wed, 06 Aug 2025 02:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754471505; x=1755076305; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JBLc7ArxlNR8pTtajC/NheRkCgoQRk7tluXtx6UCq6U=;
        b=K80YoHgV7q4XSJn2VCc9KoCxtLyAZavIj/D4th1IM3gqDlDyxaOgY27uun2/YGcMFV
         ESKynfQdeoR+3Fdx1SqKCIxxI+SL/IKv/iduOif9p4mDaA2uk9QfyXujhwtQWVGBnNIz
         7iEDfY2XszQGcjQCj/p7FqBC/fNvhKtHgyp5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754471505; x=1755076305;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBLc7ArxlNR8pTtajC/NheRkCgoQRk7tluXtx6UCq6U=;
        b=B1sLlO91RudpUE/WNamxRaZLTv5qyogeMWcpmINw0JdATuaHhgopri+3ikgCBVTFWN
         V54Z1e8CceuNHbtrCwAXTnQouXAp4D58Ao8g2BAme5v9AqOM1acxozto9vJtaodQqfHq
         8Xk95IPJjHbrqE0vFU8Buuq6G+7ns3Dz1wDYs7OgovWLoK3wVVbkt7Mpd0tI+EgZjiuj
         dvh7QX9H/YqLlpRfalliL5S5rdSsRH+gnPxM79DDAs6OmLKoAoH+Mq5V9cSIpTKKMTa1
         L+qELYtRSQuOIeP+i85fSA8h1T+loJO0k8vFY+EuI6gqWEqPqR72xMoIXBluJr/PN6+S
         Aarg==
X-Forwarded-Encrypted: i=1; AJvYcCU+460Mia9KWMBfxucw+vUXmZujtZMQ1Vf2vZ4Xs5tImzqRH+z7XWpqI2ycZcpm8xNunzYSxgQF2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjKzLjnST+xbTl3aWScaAH/jroZ0b+FTaiuT1Jzbxa1BfB/aoN
	DxbaDQSfHqXSH5R5hyToqIMGQBsZlbcKQNqpjNqIM3FqKB/EeNQX5Q5ryg4kX+FsFSE=
X-Gm-Gg: ASbGncvuSt4+lDlG633fxNydXIelHMEkVl9dkNzsMlTAuPGsLuihn5k74guGFcsHDnT
	lm2Kycto4KPJWVRnS0nMcdTe2o92QhJrKZRkTzH50B1Ff1QnTq2xh+Ed2X+PNhv+U8tN6rGJCSp
	94PvsqZ3K8wO28fyeefMLfELLaGM7YEWHjMNmSvL88bQ6SQmXnlQMHgrym6ZAid77si0DP4sDo5
	GrRgRWsAozzXOMPv0eDFPyaaT/2YOZrQt9S5Ji2XetYAUoAeqDlVeuhx5elt3XJp2RQ+yvaU/ya
	NEqEQwVGUjZhTl7CTW4xLZMiFljrKVeJq2L1Z9puECswSv85h+JJXDI8VjNkl4KXmNvURj75YqJ
	N2vofpoXmoXolnS7K0Y9AVPLOeieQQX+NPE+k8zXUDSyG/o293Dyq8upi
X-Google-Smtp-Source: AGHT+IEWkAjBZFDYdLy50hCv58jLmZaDBOkfpqI7EJKFdUOgiLxmusBsskvWsfDmmjOSSkTedEuBhQ==
X-Received: by 2002:a17:903:948:b0:23f:e869:9a25 with SMTP id d9443c01a7336-242a0b8d68emr25026705ad.44.1754471504994;
        Wed, 06 Aug 2025 02:11:44 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b642931sm13045501a12.0.2025.08.06.02.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 02:11:44 -0700 (PDT)
Date: Wed, 6 Aug 2025 18:11:39 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJMcS1aE3n9gYMOy@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <aJF9B0sV__t2oG20@sidongui-MacBookPro.local>
 <8A317BB0-750B-4B68-9C62-2732DA3986F8@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8A317BB0-750B-4B68-9C62-2732DA3986F8@collabora.com>

On Tue, Aug 05, 2025 at 10:02:18AM -0300, Daniel Almeida wrote:
> Hi Sidon,
> 
> > On 5 Aug 2025, at 00:39, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > On Fri, Aug 01, 2025 at 10:48:40AM -0300, Daniel Almeida wrote:
> > 
> > Hi Daniel,
> > 
> >> Hi Sidong,
> >> 
> >>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >>> 
> >>> This patch introduces rust abstraction for io-uring sqe, cmd. IoUringSqe
> >>> abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> >>> abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
> >>> pdu and also sqe.
> >> 
> >> IMHO you need to expand this substantially.
> >> 
> >> Instead of a very brief discussion of *what* you're doing, you need to explain
> >> *why* you're doing this and how this patch fits with the overall plan that you
> >> have in mind.
> > 
> > It seems that it's hard to explain *why* deeply. But I'll try it.
> 
> Just to be clear, you don´t need to go deep enough in the sense that
> you´re basically rewriting the documentation that is already available in
> C, but you do need to provide an overview of how things fit together, otherwise
> we're left to connect the dots.
> 
> Have a look at the I2C series [0]. That is all you need to do IMHO.
> 
> I´d use that as an example.
>  
> [0]: https://lore.kernel.org/rust-for-linux/2D1DE1BC-13FB-4563-BE11-232C755B5117@collabora.com/T/#t

Thanks, 
I'll rewrite the cover letter and commit messages that reference the example. 

Thanks,
Sidong
> 
> - Daniel

