Return-Path: <io-uring+bounces-7682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF23A99850
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 21:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AECF1B687DC
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 19:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A188C266569;
	Wed, 23 Apr 2025 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Elg/cSaB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D41E04AC
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 19:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745435174; cv=none; b=sSK24aGLK8xKT2ozulHMNWdOYy5+720ehgqpCW70UXoTqtnJ9ZwOGYX+m2EmLG5eVBpXSD5wlSAkE97fKVOxA6aDycuoBL/ENzO8hlQhN+cNf7E+xQp/bUYSJMTVurhbH9W6gOF05PU+Rq2Zhkp6yvFao8uzZPs6gXP9hP+ABoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745435174; c=relaxed/simple;
	bh=TRvYsrGHCy0xkhWn07V6I0pgK6cbCJta3O9PYYHdOPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AANSVHagYVZ/3T7WPyLFqNhEK5k5saJJ2O7fo7OXC2P6WKV6Uxqa6yPPjoTszonJ03jABeyRACKKaBhkingMsLuiRzOVVwNpCAgtN/7Q0w+Sy3n2OupKb1s8f5sitGsPN9X6aHn671r9Q4+Zry8jjj9r8agR8RmXaSu6fs7Jf4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Elg/cSaB; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso36030166b.1
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 12:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745435171; x=1746039971; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PZgTMq5PhFENQVc313T/PuxVmWJtVJmCY9hw3wlog4A=;
        b=Elg/cSaBMAVzCGFLKcnwxnnrEJipXJu5NLfKMwSgLe21WPBH9fxMgUnDL8erwsYvjV
         wLJhxgrgAlUmeFK4SNhS9JstUkY2ZUwub6A6FQKemfOOQeRiMtUU1dARqJlWaGa6QYoQ
         /Yv0S+HlWWVtotWhhkH0BJXAGql10KTIkHs2zXRnKlEE3JR67IH3m7CaupbM958a/+mM
         oSlvFmk6mejvJ+gqYS2ciqlHDrFoQv5u9R7gQwgkoeFzfc4/JQhc9c12+hjaX2X0mjas
         QkM0H8WohRVgejBQESzW+un9iTgyJPToi5rLkvMSUZmommtmUUN7YHQjbBwT3oD703Qd
         j9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745435171; x=1746039971;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZgTMq5PhFENQVc313T/PuxVmWJtVJmCY9hw3wlog4A=;
        b=AeLGGctTlhCPWDnK50G2mmzanQIljnwXZcu91ns/Vs05uMak7WHBdReD+gXoF4Pivw
         +s9yEULkTzJmNWUfO5rRzUOiNLV6gpxVwswzX7+UW25PTm8e9TzilxH+ZfNLTRzb+DWt
         Ij5e12VL4sXx8D+653RyE0gcFT3XUTZM88CmsWWkIjco4kta1Q6lL9GyFR4H2P1aV2T1
         nUSE5phvoiUtyULgGtf5wAgD0b9RGrKG/11P3vBM67+dOnn6T/ONAPUSDlLsQFC1eiXE
         kmseVfn5/N9Lsz8mPKDaEXrBjG32gYr/jcprwf5QAjBAcCk3gltaG/AGvvqVD7NJYx74
         ONZw==
X-Gm-Message-State: AOJu0YzfEVQxUlj2dzH0kkCuUm6WCHd5eB4qcfNP9sdaRNiPhpXg78Nm
	/UjZCzZK8V9Bd7V8Fz6LS0Vznv5cSgudxKZ9cqImcSWdQLovKovfnh1aHJ5kiX8n398gp6OhVJe
	F9sDX+oh0qOgwPif/gE1CvhavT8SeJwI=
X-Gm-Gg: ASbGncsBbC3w4wcbc3gH8C2O3vDNvvov99DT1TXCR0v/Xvf0s16LoKXbOzbFp+zU+oz
	ssCLqWAq4zq8xtoRxQXIzgArxH4funRRycfU9kCor2hP7gDlmIi9s9pp6OVWYhHnIivCl703QkS
	jxLQIYAstUa+g5BfBe1m/E6ml/Uul7eMsEje0cQNZY67u3aDlfIXTBh1WcBPVOM4E=
X-Google-Smtp-Source: AGHT+IF8fKC++lACZIICd3VVqFZf72OjZLPTJ448el6E5835bSyauyn4qB/QeWs1rvcZgBNYMa3HJYcdHTrByzC8aIY=
X-Received: by 2002:a17:907:2daa:b0:ac7:f00d:52ec with SMTP id
 a640c23a62f3a-acb74e79c7fmr2079759666b.58.1745435171024; Wed, 23 Apr 2025
 12:06:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b@epcas5p2.samsung.com>
 <20250423132752.15622-1-nj.shetty@samsung.com> <20250423132752.15622-4-nj.shetty@samsung.com>
In-Reply-To: <20250423132752.15622-4-nj.shetty@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 24 Apr 2025 00:35:33 +0530
X-Gm-Features: ATxdqUE2NVLKsRjFz8Erim5rbYDqz6jETcEMkzrQ4_WxfHvdL7khNxJv5siy0oU
Message-ID: <CACzX3AtPziqFXmFvysyfCSLuZhGzppxs7k1WbHgrQweSn7V_zw@mail.gmail.com>
Subject: Re: [PATCH liburing 3/3] test/fixed-seg: Support non 512 LBA format devices.
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com
Content-Type: text/plain; charset="UTF-8"

> +       ioctl(fd, BLKSSZGET, &vec_off);

nit: vec_off might be better named as block_size or lba_size to better
reflect its use

