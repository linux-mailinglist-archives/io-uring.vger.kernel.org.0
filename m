Return-Path: <io-uring+bounces-10789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FD7C8550D
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 15:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77BCF3A408C
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 14:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376393770B;
	Tue, 25 Nov 2025 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1zelY84o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3468631961E
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764079470; cv=none; b=ZaQdX29nkdGKJYzhR5R7g4UyZHmjC6D5rvBZFD74AX5oBt3Bt0rmTZlwBmEv58G2mUzaLLzLHbnpguMky5zZrh+Fv9RIt6rxEOkpeOkrSlvNFQKa/8Dxt57jaVL/44ymIigpBNPDg2gDTmAdXDqMKBQUXnZ1XJ51/9bzD2ijKyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764079470; c=relaxed/simple;
	bh=p4G9N5VL82+8fDGeh1yk50R0ZJsGQQ1EeTjvcfTcbuM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=H8b3GtkCTExfWBfmIe1jcHOEBLFcCLSh/Me2Y4hAhTJ8yLuGchGFWbYgIzKBKXKngapOnQDR8nXgmR25p7ySyR9TtDYcxw+zIgPJfcy2xXMrgWt9JfD1Sk34/eQ/rh6iIpdoJ0M9hy1Ewz7aT9Qdr5gAKb4Vx6eG1lJyY41LCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1zelY84o; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4330ef18d8aso22304435ab.0
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 06:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764079465; x=1764684265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2qZLKk0GKOWjR7LV0DnggaD4uD+pKx//l9UJMYeLCk=;
        b=1zelY84owpTUd4HDgUfuX1ElvXgwrncfG+kf3WgZJxo4F/b5JKseeu/8aMiPTAZ10j
         L63LgOMFnJBXbYlzO4koUxNpvso6nyttsavIgDcRkv/fqnkLHTIayn4tiyu3SwmAhAuk
         YYHe1NsrW2Oj3ExilkhDbQMW3lb2+uEcsvK4CoJzME9rC86RF5kuIfpoZ/qBIPtsm9Uy
         vuaIyRZmYLHXxBsV17X+g73iVbmZ2cf20Q719B/cNDSOXNP36yyQxxiu1XIiUf/pXkNO
         6g21HKuzSEXX3m/pN2i4rvI4nHJZ9Y7E89gLrGxoZ9TGGWOSsQmXxfhEjZ+AuL3KOaaE
         JG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764079465; x=1764684265;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m2qZLKk0GKOWjR7LV0DnggaD4uD+pKx//l9UJMYeLCk=;
        b=iAl9h5Yi7eKq7RyP+6MX7L/FQ7DqgGjTI0rv+w31LHKzWSap5jmfrm8/BTmkgEW6HS
         77OxVkCcVlWGwCBdFwczgjGsF9TO1jJ1wTTwIzGaWbAMwaekGs2IbydbkUiFamw7IBTS
         M+/TE+XAAcQXXB66Uw4lfA7jCOSGy+lWqhkXSGQr8uyrWA5tyvusSJLZidrHiH061jfT
         7AuugYp3uNNrguzJTzSq8lytgakVvS0LcSXcjANJ/qhTjYmpnaD9ApnOChVNrs0umagl
         A2xWwqzoiQq8+Dc8h4ZjSGaJSeQs1c1c06KwICK7mrjjwsfHW4zuPJ5Q+l1Zs9C8UeWy
         uZhA==
X-Gm-Message-State: AOJu0YwqBSSzSMG8pXojQ6XBfeWa3xfd72/+zY6tCUU81LcSgTdme4by
	SJHukOWC1AmSoHiVLdwXLdyNtWyOCuscTSiGPuWSKWbHJde9oJ1wIkvN42YntwqJkpe3IFb5mTO
	DXMNo
X-Gm-Gg: ASbGncsrKeQyvjQLVQqP0StE7NteJTnyuhqYHXHGqM6DGoP5f73w3LfAyWWq0AHfZwu
	kWaStYGYRjXx1Q8C1pHFEWQgCSJbtz6xfi4M7groDk6Fs1OYLpDOux7NJq3zVrRLKnAOgWY3UKU
	k/njWtitQX7MRgREAjhs0g+nApu5/StTzXwJwmJXQK5tVXjHBRHPz4rJRPKE4giLkuBNNvE7xIK
	sS5ZExVswyrE3EimMS/qcvkq++dDKODxPHEtJXbWYi4J0f8uYfYJsFTx5I6IgGrKM94xn/OLOho
	Hu6JsJuNaX1noc2sWMdp7jjCYQWZ2OGhqjud98GaQs0jTaT5e3WYmOv7Cyv1r8m4W39pyzIsCOK
	a2rB6Zj6d25dyzS3XUHj60R4EfRFDzXrpHqfVnYXkvF9qCpdjChQHbsp+qmLlSAXEU7rfqUlFlw
	o=
X-Google-Smtp-Source: AGHT+IHFLeSw2MAi0ga09NsjQnGCwYSdgyJLqsckwE3Fy02SSe5uhwUM1fOZja2r4v7qV+vS+ewuvg==
X-Received: by 2002:a05:6e02:218d:b0:435:a423:35db with SMTP id e9e14a558f8ab-435b8e9a97emr129715855ab.39.1764079464846;
        Tue, 25 Nov 2025 06:04:24 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90b6babsm73512675ab.20.2025.11.25.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 06:04:24 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3f8137e8c7183817bd7830191764edbd3a59d7f9.1764073533.git.asml.silence@gmail.com>
References: <3f8137e8c7183817bd7830191764edbd3a59d7f9.1764073533.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix mixed cqe overflow handling
Message-Id: <176407946382.1069147.4213690256618739450.b4-ty@kernel.dk>
Date: Tue, 25 Nov 2025 07:04:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 25 Nov 2025 12:33:06 +0000, Pavel Begunkov wrote:
> I started to see zcrx data corruptions. That turned out to be due
> to CQ tail pointing to a stale entry which happened to be from
> a zcrx request. I.e. the tail is incremented without the CQE
> memory being changed.
> 
> The culprit is __io_cqring_overflow_flush() passing "cqe32=true"
> to io_get_cqe_overflow() for non-mixed CQE32 setups, which only
> expects it to be set for mixed 32B CQEs and not for SETUP_CQE32.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix mixed cqe overflow handling
      commit: f6dc5a36195d3f5be769f60d6987150192dfb099

Best regards,
-- 
Jens Axboe




