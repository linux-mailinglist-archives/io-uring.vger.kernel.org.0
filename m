Return-Path: <io-uring+bounces-7790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FD6AA5052
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 17:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB654C883A
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 15:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC42E17BEBF;
	Wed, 30 Apr 2025 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PipFcHIJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F26261568
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027185; cv=none; b=uyOxm86Fm96sKOcPsXa1VuPrGt9/JID++6RiMs0+yqY7cOf6e4bL2qQWJx/3tRDmwOBsitpKqlUDMnkGv4AoLqf0X/TzTL7J0gKCAt0Qth2d6MNatBXvyXGh1R6yoZpcX0kME3bew819tO2FtFvApyFRYnPeuAVAdn2hJy2TWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027185; c=relaxed/simple;
	bh=dLZLRuV8lMbqzPqrdxOtazr6wk7nhJFL3mejE34WmUI=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=cwgeSFwZJTwmnfRejubixz+FyRLtIoySAK6dI1/P0ihr3EmvHSMxxhF4aKcJFHZBqKpwMe9jO/hfIJqU3w5yrp/xRFLSLwbtC74pQelwqpcArfpbTEOO9qm40DawXJLggPenRHT548ZGmoFEAdDu32DMQpX4HCbERuKFdZW55E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PipFcHIJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d0782d787so46313225e9.0
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746027182; x=1746631982; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dLZLRuV8lMbqzPqrdxOtazr6wk7nhJFL3mejE34WmUI=;
        b=PipFcHIJW8lUjNsTP0Ave7NJImQ2wNRpgzN6oKN6FlQFeU+25sqahtqeLvhI/E4G73
         XTiwipj1ppNq+ymL+rUvH+f9wWRJ8AxpgvOA40oebVo49XC3yws+UWInHn1Ul+xwNxgg
         Da79OslFrqSYeIMmjAk3OomcefWnS581gZtc6oC8KnP+CxM/+ravxu8E8NUoxjqvFVUP
         djzuSpF4S3H2C1ROJPUwb6k1FfpzJTF/5wrY36i6wDk0RoNXCXcgv4wT6DEnWnOy3S/a
         7/151ssGMpX7Mi/gwt1bPTj30x8cOW+njfSnnOtnBFbbVcqyE8MXmk5jH+HB9P7FAOHO
         ///Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746027182; x=1746631982;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLZLRuV8lMbqzPqrdxOtazr6wk7nhJFL3mejE34WmUI=;
        b=D2jD4TFl4sXFRZ/C/b2TNn3dUu7rRmPJAsszfhXWDWZ+geRxVfHSWTMQg5iidSFJvj
         RFy4o0vJi0Pxk8Vk5iBQEPp+nbMGYE8Wr5hXQaO+6EjT/VEwJrxBQ0n+KOtXrOEgyn8P
         gy4ZVS/Dlxuq6f25+4QPipf79W45bujDhMHEB4n4WbxV6aeZTDFHctFCGbZLC9gbhONS
         2HkaIuKSSFWOiq/skabyu+2VHUVU/pgTLdMau38oQMBfHUkjG5qT2LU8fHdYQ8qkAN0D
         NfaB+MUDXO277r9Ec3+x4wmwhYe+UJRquXTFfEcQTcRhacSS3RkohIlcaQV0u8bgteg3
         tsVQ==
X-Gm-Message-State: AOJu0YxHA9uIf1SxWc59MATgsuORgO/rxmALp6QvfLIKLVEeKdZ2emd0
	LUnvBhjSSY0tF5hoGFtedIBwFMay1AtfGaWQbSxsqrqHs6vsXgPi7G/b1g==
X-Gm-Gg: ASbGncsidDdwmUsQ1y/iTDQl9Eyf6g/q37nfYGWS3A5/iiDuZJ/OuxQLHa7zyiTotQN
	6CIJfBQksuiNGvo0rszFB+RsmHvo0sl9f32nuvizPlITeV0Mgy4cBR9Wj6+8dQPQVEG+vhmOw0S
	b+v4sGUD5a8VBmpS/Fd9Uk1xA7L/1Ohkr98ViaZ9X/aCy81yGZGbSq8pCp0lzohEc368Mh0nkTL
	+M5G8K5MgdaWu6mO8/Dvznl5z2p16WrIFLE6sLie0qmB+e6TbvId7NL7MatU7TJNOTS0Sk1R+Tf
	J7GROeaE1l61uI/STKQnYsjzaB5IzvpvlGnW2qATKGTRnLm7pOtKBL9Z8hEoSwxGqWeZtA2Jo6s
	zt+UyY20GgdOSEWkJLZ1qNgB7/a8Hj7acYXJZnc35ZngxeVVK/2/gTsEX+R1rBONhX+Toj4gTfm
	czayQosqfuhRw=
X-Google-Smtp-Source: AGHT+IGYe2PscJ5Hne+ot0VsJTGnYfUUXoAuW7DXGVGh0d3FwedGgZZwaaBpNM+4tFcBFS02HEksBA==
X-Received: by 2002:a05:600c:4e09:b0:43c:ec97:75db with SMTP id 5b1f17b1804b1-441b1f35c34mr34280385e9.11.1746027182042;
        Wed, 30 Apr 2025 08:33:02 -0700 (PDT)
Received: from p200300c717029ac0067c16fffed86f01.dip0.t-ipconnect.de (p200300c717029ac0067c16fffed86f01.dip0.t-ipconnect.de. [2003:c7:1702:9ac0:67c:16ff:fed8:6f01])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2bb5c6asm28674215e9.22.2025.04.30.08.33.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 08:33:01 -0700 (PDT)
Message-ID: <edf639304e2401047a791b2de7254f7613a390a1.camel@gmail.com>
Subject: A write to a TCP-stream overtook another write
From: Andreas Wagner <andreasw3756@gmail.com>
To: io-uring@vger.kernel.org
Date: Wed, 30 Apr 2025 17:33:01 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Dear everyone,

during development of an HTTP-server, I ran into a problem: A write to
a TCP-stream overtook another write to the same stream.
Currently, I have a broken-pipe-issue which I'd like to investigate
before sharing the sources.

Regards,
Andreas Wagner

