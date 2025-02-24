Return-Path: <io-uring+bounces-6671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E8FA4208A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA5F1899ABF
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344EF19D8BE;
	Mon, 24 Feb 2025 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSrZnfF9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF8A23BD1A
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740403417; cv=none; b=ZFDq6feCU2rkRQsfrtBQ+LPWVXo2Ri50TlnotkeFWoi6OIMsgTpg2gYArH+gEZBgvN3ibLk1DzMJPq/GcNqvH0CmE/oQNAaBenrzAV0QuuqkRI9wzcP5arMC3dkonjoSK8dUl21LuK5ksi3B157ScwVKWCKKnPnlDpaWDaHHTB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740403417; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCWUfEr/zk4ScR4XBqbsHn1YpIKI+9WEdlyDfDz1YemDlmmld3EtSyDQcHT6tzzUyS27BPORoKfuy1V5Z12A8JQxFbcnpqsmQHgyFHedspqNCMedoqUGng8/KpOGPU2f8kEmvWJSJ0aQCnRr3DqXDV66N11qHjyqhN2SLfZ+znI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSrZnfF9; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab7430e27b2so692169266b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740403413; x=1741008213; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=iSrZnfF9Wlq2TgFanxF4yi3gzYV3/5AG4weIKQ3T3a6ettSA3dsgdvueL5lJE82yCp
         FeBuq2cYdfU35nbyg9HmivWqdcPQ3U60B9SwopuHmCQCC1cApMl+JTvS7/Z3LAu3yMOL
         DOZ44hCuwggByfs0N17hgFvpbB5I8R8PITjL+/yKZpiv0YP+rFNayWR6hSazuC08IPqo
         JLqH8v0bINdu/wdfdR4m5L8b5t+TY+cfYSr3/KYIoakTu6+HzlLsdXAprGyHrxN1qfMH
         qefj/aRi32rd2MF1LM70sXqzUFewGR1FKg7TOCHn6GadKcX9uFJcG6a1IRDXi8sG35Ww
         91Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740403413; x=1741008213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=eMP+1ns/tkbeZ6aSQuCdbO7yn4TUv84bTvmDWEuQ+9bqJdkC9j79sgElREMN9cudVj
         9GjyJiiY8nDAfgQLNaMi/tLvjxUEcbJ8VXn9nTPVAjrhcSCQdznlDEABFRV1mJiNRUBy
         YgC50356HfBDZnL4dZAep9Jn6IN4CXtw3z2cAtCv6SY2ZjS2Q0RRGQr6UzPkIw5mZ2AZ
         9wr8GV2AWdY2ly+RkMaYn+fcrSpu8h+Lrve54hjJkoPpxbNVlapGULSbmBzbiWk81EWH
         8/aSG/dVPQHHpEeJcw/wuTSAdIxJMgnJjoKGE+yhXcG3ybompzyPHj6GabEQTzBcKNsP
         vIzg==
X-Gm-Message-State: AOJu0YxZDhc6QbiHPdYCuZmFHxY66oV9dQMM1Asf/eh/ZTebRLOunwh7
	XEb1pzDglnuSp0sp+pXG8ifwgMAG7I0+t8W9KHTLc79lBcNFVsZZiXW7CSxQ6H44vUgPo/xtY8D
	eeI+1BMAWeR1uNDcXv0OlveOL6Q==
X-Gm-Gg: ASbGncvZbhRffeRon/k1SOVII2utlWs2u7QdCm0QhO5dPPZ7gD5OXnDSH70xxxJ9CWs
	mLgiLoPZGu/j2vMcLz7iv9kchVcaltrHncQtc7O9oC7jOWMC3GbiOAtehaVbnU5A4TbM4G6v4ko
	aEdE8/zsI=
X-Google-Smtp-Source: AGHT+IEsXrs7oUz9/sq3SSRKR8WL6YLhFkuMdQkOQIyqG9kMPmi18NvwHpdgkGzHMCuX8DN1p16ujurqR2F6TwVRsYw=
X-Received: by 2002:a17:907:d26:b0:ab7:b7e:65c3 with SMTP id
 a640c23a62f3a-abc0d9e427emr1064372566b.17.1740403413186; Mon, 24 Feb 2025
 05:23:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <2819df9c8533c36b46d7baccbb317a0ec89da6cd.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <2819df9c8533c36b46d7baccbb317a0ec89da6cd.1740400452.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 18:52:56 +0530
X-Gm-Features: AWEUYZmPks52NX6HhhwIfomJ4FfvkZA_raJK5r_Hv_OENTwD1llsvMkAtDcSoJY
Message-ID: <CACzX3At0DAr3Q8BzSoyCW+TY7mM4_Sz6C0NcN+kkasVnEa-hmA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] io_uring/rw: compile out compat param passing
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

