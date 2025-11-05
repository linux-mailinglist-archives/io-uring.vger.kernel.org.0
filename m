Return-Path: <io-uring+bounces-10380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C0DC36646
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 16:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 975E9622ADB
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 15:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1D632E727;
	Wed,  5 Nov 2025 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NnEbhjT7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E85F32D7C7
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356129; cv=none; b=Pj9NfQc5bhdD3A/jOyMm5+qzlN5GtxWj05NuwmhgebWViu+CZ6YjTIFG9FDf988zJWsgMTeqwL/6aSS9tcdYoJyXUF+FgJjL+aBiTdf9Gas8tF34OO2egCGOYhn7JHP5IKqyRSrONJUH3V40hfckvAYEdYcxHaGbxD9rNqa5QzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356129; c=relaxed/simple;
	bh=BPl4f0kGMwqvUNNCskvIiTJgnt1l69wPx6HpXTD29Lk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tYYhLGSQeu4KOMUEXJjPQayVG1x+JZcpNekFiTXofZk0WPSMNJitgcI0Dg0YE/r98Jam7lGs15ZjT8LugubITjBTlMlDhvoZVsFtmigdOPhhI5wi7A22cKz+2Cyp5sHcMzlwoPoIvV3ZFylpomHS62+9EfzMIjJhWYS0fDL4pB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NnEbhjT7; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4330d78f935so48845345ab.2
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 07:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762356125; x=1762960925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bvSR5Jr0En0CjdZcnySXtP3VB9ind74X+kCeyHqoCU=;
        b=NnEbhjT7xOpziKQqKoqlenQB5SxzIyUxz4+1fh1P4B64OclzJ/45AUjKrOcbMGpI8d
         KvSOgdxNlLNSWOBAD0kGqYoi4s3tEXp7lGZnQxImIWFVcpkv9qPhtK1du/K+aLbm8bBf
         0o6lxC2UFw5+YcMWxeTKYICGaUO66c+Orj7BFyOYVuNXiHx+UfVkwzovQRbXHBky10rm
         VyOhxoRxZQP+B71UQNr+GrgtOEhMhmAVDQBz8PoYP3uWovZzcg8k02lUs/SwfHKKT/Wk
         TdX4j9S0Gx+PkUDBiWifbi9sPivnHfiEPKIqeGlDRcRIar85Did7Ei56BrHt0rguN0LK
         HE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762356125; x=1762960925;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2bvSR5Jr0En0CjdZcnySXtP3VB9ind74X+kCeyHqoCU=;
        b=KPU0yGEEPJLbFRz8U5gP44UlS7dNRvubGpn9tX9qF1Bv9XqWD9erdHzzWkZqoY3wiv
         IUpJxNysamXb1ODCteC31zPZeqT0wV6IuPaf4qFdZ3XebjFBMXSiyiJhI+tTb7rMryAe
         hlsu5lAs5MarkZd6iVAsKkFv8pyZT239Sn2gzUaUITLiBeBuuf9RRn46RB1E1m5jJeuH
         YlXxWG898s6hOHZKPX+2Huwn1VfVkbK9YxJk+SwCE83ictKE/9+uHKqjTWKvk6PXWpcp
         RAgo9pwExdu/BqLD/WS+W2iKfVKVWdx3RL6AMKTNqAePdZp7SFnGB0Cfz0UnwctWDtSf
         FFNw==
X-Gm-Message-State: AOJu0YzaJQOZEBFMXrXOxIxH99TlTqjlSO2ti9HCxSz4ZrGCN4J7wGI/
	O0PhPSbjszyLxMHSFxxwH84Abg3o2Qf7GqO5RsjjiAuRXEVpFOMrOgxo/gJKhDlkaLo=
X-Gm-Gg: ASbGnctWHBs8VkWb+h4IyRObYAPR9Ixs/TjRGg//b8YZ5vSKWEs1qpspSB7JDPIGbcQ
	t4yU/yxkyiUDQHkyXTDV5kYX2bakmL2prX9QCgvkYY0bSilZgxiA3slGZkDWg8iH6kS60b+C9gV
	WloiLFMPqWTe6gapkW7m7IHxJ8+cHxTNjVeksD18vUgaQUicJzi+TZx64gE2ih0Y0Guok49BoZY
	YSKp6nc8ic/ZPgwqHL2ygZNwOkEsUfufSCYQKcMGqRzKd2CT1TX6QKO4TBpTk0g0cLKJqhNQznM
	vn3eti7PI5uaoTPQNmckaA2UgeKjdNPZhElOIswvcClo+hRuAKid5+AvnZgn/YGS7h3kYgqUhxr
	QdBRVW8lk51myA294EyRAVEOiQNAHDsCKIzWfsR0yRWPgnhCpz3CEyiRL7FJVTvvGVd0=
X-Google-Smtp-Source: AGHT+IGgbZ0vn+KU5M8NlljaajWfXXZSpCXQefLwwYSK6kCpZ6hWrSXMI75cWEZsKOqdWMpPU5Fl6g==
X-Received: by 2002:a92:c050:0:b0:433:481d:fd60 with SMTP id e9e14a558f8ab-433481dfe34mr15899845ab.17.1762356125614;
        Wed, 05 Nov 2025 07:22:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4334bf8aaf5sm3375295ab.28.2025.11.05.07.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:22:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: alok.a.tiwarilinux@gmail.com
In-Reply-To: <20251105050124.561575-1-alok.a.tiwari@oracle.com>
References: <20251105050124.561575-1-alok.a.tiwari@oracle.com>
Subject: Re: [PATCH v2] io_uring: fix typos and comment wording
Message-Id: <176235612485.187572.3632251868339097584.b4-ty@kernel.dk>
Date: Wed, 05 Nov 2025 08:22:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 04 Nov 2025 21:01:09 -0800, Alok Tiwari wrote:
> Corrected spelling mistakes in comments
>  "reuqests" -> "requests", "noifications" -> "notifications",
>  "seperately" -> "separately").
> 
> Fixed a small grammar issue ("then" -> "than").
> Updated "flag" -> "flags" in fdinfo.c
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix typos and comment wording
      commit: 59f44afbe8cfe7904e8cf8d2bb67eb86b79e58da

Best regards,
-- 
Jens Axboe




