Return-Path: <io-uring+bounces-2542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0583C939811
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 03:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B433828115A
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 01:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B0A1386D7;
	Tue, 23 Jul 2024 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOVnCG1Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE2EC2
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 01:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699565; cv=none; b=IXS3RAs+K+wvtPzkkT/7f0fwewKbuWA5LLw1vstzkVwW93alZflayf5hCV/zViHla+KCs7Qwgr7rAV22iMQdkHPPBtjMjXgodNQ5A+8aYixB0W6ut0fwQvln1HfsFoCJ1Y0gM/UyuO2CD84C4O1jobnalkUmDdDkmIPuEPMkQuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699565; c=relaxed/simple;
	bh=OfqZ//3OxReMquU8+AGgL9xNgwmaunZOL/+qPFEzY5A=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=heuWuqMi3ZNLOawLieK2P/wyZ03WBO4nctYkNw4GBoOXda61WbFbbU5a7HBC9ywi+s93ykDpI5EbREJkwa8A5ChT/qR8amNQCXyFUBQasC2OEdLfblvT1ZAm/gOkw3I5N5AsBGKroOBuT2C2BEzx54km3Q2xNsjt4WOyzKr7UaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOVnCG1Q; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7f99d50c1a6so229917239f.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 18:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721699563; x=1722304363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject:to
         :from:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OfqZ//3OxReMquU8+AGgL9xNgwmaunZOL/+qPFEzY5A=;
        b=AOVnCG1QSpObLjneBL/AK2ribClCGtoxu3LX9mAGkQmWLx5G/eAjOZguz1xOFvNStE
         /bbOq48YQ9kFj4Ua3OPXH/Ed1rQdW/zNFoTwAG0sFOf67cCgePU9efwa0xw3A3Vch0Qt
         GCEA0JBNZnfPpYISwTk3hJKKB8P5rkMx43ujeHMb+s/0HxV/zQ7TImOb3Shjeg0A04ic
         oQ43il5kri/BTT0U8I6eG4epI8jtT6EK2s5BJVccsa8X/215jmnYBeILA/T7ixGCx764
         i2I3VFjiHt0Eh2BWaEjS7EZNjZKKHbqc4/xAO6B+Gqkjkox91xM5204VK0fxyfIIYMqC
         H9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721699563; x=1722304363;
        h=content-transfer-encoding:mime-version:date:message-id:subject:to
         :from:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OfqZ//3OxReMquU8+AGgL9xNgwmaunZOL/+qPFEzY5A=;
        b=mXp/pcCwp7bNHZ4RKnh9oEHRYmwFpRa6WrSLH7czBrQip+Tu8ljW8F9eWgd3P3hJru
         9nseWqgqaWD3ltwxQ/gAUpMPU2/k9OYYHsq2ZVXirhA1DHGLlW2oyHl9ybeI68lqipRi
         kYXR9CKno2VTihBfrxWrQ/0g+Mg8g7RWEFVk/hUOWRMiXu/4TnVE+kreg5hGaCDZQRid
         +I4fqDWxz9QLatmcQVEKFdLG7jmjndBULquTcsYQzp3yQOj8VmAtomIzWhA8mz42wywX
         pCPrWWZwGRafpVfE7YIpiCDWn7mARCKEPD/NubJdcibcc7ZTvqcLXgf3pFbXlhBrSb/7
         jvrA==
X-Gm-Message-State: AOJu0Yw/iUJn1GmI5FkIe1fK8ovA2GBKzY3G0sC6HW2ca0EHoV8i7xgn
	Me5bMG/Civ/Lit1ahXR0ayqZcsCPQd/ewh1PNIqa/F4ZRv6TVbK06TAmLvPY
X-Google-Smtp-Source: AGHT+IFoovIYiun6gz5CJulxhdMjjTm6KBKHEnnOXJnQ92rTMHtqOY86IFGUXe5ojjjI0jidhZN+Cw==
X-Received: by 2002:a05:6602:26c3:b0:7f9:59af:c26b with SMTP id ca18e2360f4ac-81aa70735f4mr1677248139f.17.1721699562727;
        Mon, 22 Jul 2024 18:52:42 -0700 (PDT)
Received: from DESKTOP-VFHUU51 ([217.148.140.143])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-819ad823f84sm277303139f.42.2024.07.22.18.52.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2024 18:52:42 -0700 (PDT)
Reply-To:  <luisfernandezconsultant@gmail.com>
From: "Luis Fernandez Consultant" <lconsultant04@gmail.com>
To: "io-uring" <io-uring@vger.kernel.org> 
Subject: Re: Kindly Get Back To Me
Message-ID: <81ddde0fb8f3b545965eb80400833b8c@192.168.1.15>
Date: Tue, 23 Jul 2024 03:50:16 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ascii"
Content-Transfer-Encoding: quoted-printable

Good Day,=0D=0A=0D=0A=0D=0AI am Luis Fernandez from Madrid-Spain. =
I have a business opportunity that i will like to dicuss with =
you.=0D=0A=0D=0A=0D=0A=0D=0ARegards,=0D=0A=0D=0ALuis Fernandez=0D=0AMa=
drid-Spain


