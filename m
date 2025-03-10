Return-Path: <io-uring+bounces-7040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6331FA595DF
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 14:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B1A916D959
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 13:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48B222B8A0;
	Mon, 10 Mar 2025 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TdBZTmxR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D137122A4DB
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612496; cv=none; b=KX2QEwRABt0ZiML1DWmap+GikJPscbUVFe+YObqUarBSN0RmQw5fwmSdo4sZCwnhBnetqEuWERlplv/ncvCVLy6HtrVN5eEmI0RZ813YIdNEz8fwYp8ZvbKtUEGhjCgeFwJi+XoLIMgJo2Ru7miDLTlAfnkZkGkkC+6GwT8NMyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612496; c=relaxed/simple;
	bh=zkhhMGzghfXhe1F9gcEBZPFTqF+MEK2+6oa7VF1OzW4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BqhgGYIP/e+WtX9gwe2a5x0gGnOxkAKW7+Ox3B6oR+KprBQ7WfkyLABGLU7M4Xv/EMDlYpMcrkBRQhhN1DN/FN8T/PMmvp+SQXP6sAKuHigpm2+QIEaVwnWGcqJ2uj2T9cQSei5sgsdoTIC90TvRtiCOvddwIs0lTUe9zvnSY9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TdBZTmxR; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85b347e4fdeso5924639f.1
        for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 06:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741612494; x=1742217294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3AYfKT6m/MBWYO5rev+fZ3XuG96jiLoLcjS21ZCilE=;
        b=TdBZTmxRCR34euR29c6fx/pzFeTNHVpsn0IuONzqfN3ls5NTVhnh1ugIc78GOCqR5f
         E0ZDrMulRt4CBhjToOq9zoq1SAy7WXo+AJUcATxc6sMAntjVItcQYwRf6ll9yON30/I1
         898sErYHuNFfX10EmofrWAd2dIXLjitxWC43dDt63TXZtd6HZsBaJwtTPBwJBZzjqMur
         j3+EFl0nFjnPwNMp3iyHoOHhOSdOa5CI4j8DE0zsQWfFReLbyIywhvM0WAIq+mVqLKh1
         NM2ogV2wmDNRsekU463ZtaUZFGoIFAbzNy4lhNPptNKjfIyoQ+h2BUG0+W21boM/J29h
         ofYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741612494; x=1742217294;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d3AYfKT6m/MBWYO5rev+fZ3XuG96jiLoLcjS21ZCilE=;
        b=rUb7wL0Kd/3d0oDoSvx+AyrcI109F3Tohi4EGplIvJqFdWxW0oDsQohseqqoEX0JZT
         yaUxB0r1/HtcNnvrENwsgMEQtQcS9TatG/fCKYxN7nuhMEIZEHoQc0REhXC85yzQ0vNw
         rGcQ/xK79s2YTnRA5GIH7RJxAbbbuYzOgHaHE8IZJJ5t0sNSruJSoAxVDIB6f9YlO/sx
         S+sEQWVyubXGsLdBb0RFjn1qwDzRLTea39+Iki/vQlXhOIO5rMOSfsMo03AemBbgz7Ch
         kGcZmhzzjC4LFdpQAmKO00RlyoLYPHQfgRLCW2riAIolD35I4D7Ntv97PCu7JD+9WSlX
         lr9w==
X-Gm-Message-State: AOJu0Yyw7I+hKjLfPdyNWV54Zx//9EMvMk4+sI8R1wj/IMKsveW2Yym9
	/jQc6kBJQtUAyiaYsL1krVNufgRUJKqy0QuzeUgoFPU5xDwKNZGZznByhla2t8LqKeXF6uqn/rg
	E
X-Gm-Gg: ASbGncuxwlR3TybuFgi3y+YiI8zhrxg+pOHqLWhT9S5XziCba5rh4wnixBhfc4cVYpo
	sjDHAmEhFBJcbTmZiJMFXLD7nbLSjM6gr5/LoqRLdDx4VIPmnZ7YRlwMmaKPPnCqZU2TSZPnXFp
	zDDBD/Y6/I+Zy8oDNY3EkSBqmu7jM1kJ8rntLNC/sJkCvokE+GZBO2t7XcCHYm2Wr8GSOI7QIUg
	WjC/9uKN+CUMxXRZdFIBMqJfwxMgFnWN7/5EgAxP/J8uUQz7q42FGSpxT467lKucOgOqecOwo9r
	43JTa9/0EOXo0bvtOX6biBkNu6EDtxAJhc0=
X-Google-Smtp-Source: AGHT+IF1CFTDvxxY0ztQZypU5GITnKQU7RMTLaXVwYpACbMPKVbDqV03hyohMeqwg36HTR+V/+OODg==
X-Received: by 2002:a05:6602:3790:b0:85b:3e32:9afb with SMTP id ca18e2360f4ac-85b3e329cafmr898227839f.14.1741612493907;
        Mon, 10 Mar 2025 06:14:53 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b80032bb8sm6452139f.12.2025.03.10.06.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 06:14:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1741457480.git.asml.silence@gmail.com>
References: <cover.1741457480.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] unify registered buffer iovec imports
Message-Id: <174161249198.148284.16197765392853599318.b4-ty@kernel.dk>
Date: Mon, 10 Mar 2025 07:14:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 08 Mar 2025 18:21:14 +0000, Pavel Begunkov wrote:
> Extract a helper for some common chunks of registered buffer iovec
> handling so that callers don't have to care about offsets.
> 
> Pavel Begunkov (2):
>   io_uring: introduce io_prep_reg_iovec()
>   io_uring: rely on io_prep_reg_vec for iovec placement
> 
> [...]

Applied, thanks!

[1/2] io_uring: introduce io_prep_reg_iovec()
      commit: d291fb65202051e996cd983b29dce3e390421bc6
[2/2] io_uring: rely on io_prep_reg_vec for iovec placement
      commit: 146acfd0f6494579996ae4168967cc5ada7d0e5a

Best regards,
-- 
Jens Axboe




