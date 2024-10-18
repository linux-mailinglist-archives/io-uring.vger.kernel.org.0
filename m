Return-Path: <io-uring+bounces-3832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 726849A460D
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 386FB2858B6
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45145202F71;
	Fri, 18 Oct 2024 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EB2sAJbv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520842038BD;
	Fri, 18 Oct 2024 18:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277073; cv=none; b=daqXYCouPjW4dSoU2JlF7B5Qd9v0pgT5o3RzlZsbS8abP56pOtMcCXk7+7NlWbC2Vs+ubv7bxYoYSozYLU3t5cD0LzD2cs8Rw1DPHOSJ+aVdhXLZyWLOPd1emwm+f8hgMzwQubE2v2x51g8Xz/vkDl5Lkz0KQ4UmaSUxDaamvlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277073; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DrmnjIJDLNFF9qxbcbhAbwH3F0fQRSexKybG1xZ8dcrKIAXLxr8AxGOdSBIc0KKPHgekBktTlZMri3vUsYP3eYkqCLyifKvRxd3j3kwN/iT+/kP+a3Y8nFV9thADswLneaHX7HaC30TuNBbO2AX4uhEGjAcmwpU91cdI6tKLSdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EB2sAJbv; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c40aea5c40so4375317a12.0;
        Fri, 18 Oct 2024 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729277069; x=1729881869; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=EB2sAJbvUreS5OnRLlDjb0pjyzau6Q6A+JxkMl2RZNrWy16FetEvFi/54LPw2yBKMr
         EF3H1mekEdnAQvo/1dU5V5pMiCvYqjRv2fXeReGbMAIK//RqxEel9kPMz0obHds5LYon
         EsUfXn4jtYcyzGPSlzoiQ0hrclzef1lu3FEhgOzQInpBaY+IJkjYM+26a7EAdifYdRYW
         J1KX//1Pugw0R9+Mrrjx8flXKpkOo1MAdZWMiZwxa98ri5HkMBwcqg5D8A99Aoe1JvuF
         tm8sfeMsXd4dKIj2lPyoEy0rt138raSHq15HXliS0B48mtLh8/GmdHQsHLsqhvW/xN3s
         rTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729277069; x=1729881869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=DXddNU+Cwpu0CQdNI6FUc6zjJ5EvxFMg/5GMRwcu+xRUdb9gsxY6MkvE3r1pej9+cH
         uLeuVk5WkS1JVl0se4cBpNohbPLKPkb0A0MvMUFVILUtcY8N8RnJCh81i9hFK3CJQqyR
         zV+Rgff/VKCmkyReEs9d4iExxrM3kXvqQYNIZRkezdYjQM0KEQcihP9f7C+XYjz5+4hG
         IyyMHJMtfLzEatRXzDBz9uga7GF1IErF4BWSQaqvjIOcv1teewig0fy9SvuPx++JgPlP
         ZmPB00tJXGmY9D6Zm3sCCFxvWmk5ahsPrBPfAEaboacnaZSu5s6n/Umo/aT4c8ZmB1fg
         U4hw==
X-Forwarded-Encrypted: i=1; AJvYcCVlFkTXd/Djrdaphu/jhf7zJqWgZBI5DNOpzwuRKG1TPaRQtwBOgysIoe6g6Exd97HKE/bC0wmDj2Gyag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHbbsOOW9+66raCIGaVPw0zrKvB2U6PJvdCad37+1ISOmXw8FB
	vvBF6sKRpvVZ0P5qjEctQ5A/gUM9qFeEL3WgjYK7CvHnbGuztewCEN0gF4sBMspqNwqgx1epKJH
	Sh+jxgT2xPDV5DvojEgXpIZBpMA==
X-Google-Smtp-Source: AGHT+IHHW6d2BwI20vTw3bL79dV1JBvE1L2wF7p7qJZ7DPM9wWwxfLJvqtw7jR3OEKHBedug0VZ1O3UfHh1pFrPBhDw=
X-Received: by 2002:a05:6402:3594:b0:5c9:85ce:d9cd with SMTP id
 4fb4d7f45d1cf-5ca0b083da2mr3770993a12.3.1729277069427; Fri, 18 Oct 2024
 11:44:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
In-Reply-To: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sat, 19 Oct 2024 00:13:52 +0530
Message-ID: <CACzX3Atv=iXPvGVLyZinh64AF=tSivoxxGDAzy34Bz+Lg8+KZQ@mail.gmail.com>
Subject: Re: [PATCH for-next] nvme: use helpers to access io_uring cmd space
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

