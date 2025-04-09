Return-Path: <io-uring+bounces-7445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A32A8269F
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8ECAB7AC35B
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA2B265602;
	Wed,  9 Apr 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iw7CWeGR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC81264627
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206306; cv=none; b=oLd0qE1Z58OsMSwnajcMEKEq5CArjjx92EKJ0g4ptNZqGseJHJZfUp3MbUq4dlm3Ak2uL2fOTXVdUf62DIAQHBiA/J1kBWItEqKIVJ2THAaQiIGOjCwQ7M7oPzVVMA1kZFY/xE9KF1PB5N14ALAKRoGC9Bb+PAERnz06OPpuZyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206306; c=relaxed/simple;
	bh=l2jrB4gN2z1FqZE2CRanFafnJYhVmB2TRyTzVfSG9ec=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pYlvMN8cUKWxrSsDLJ6Fjn18RdUMAOpnWnTn9B3mClBISpAPbuCkWNXk1zpb7rzz7JxmR1/eqyGJpzH7hVLAv9QjDbHeiVKjkUPrgL+oyQe8Ig3awJXgbwhLuuKmL2lkv6EgZ9WgjszooKbHGCo7jrcoudzCMyIj9pcAmWjtrDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iw7CWeGR; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d46fddf43aso51925515ab.3
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206304; x=1744811104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GJ7PBoGlhVnnicpr1k7pW/KHpPlcAjam6ElLxsZiKlU=;
        b=iw7CWeGREd2EohOmoPERYzqNLacPdQQdm838pBx0GQWPikKk4fjNQlr0/3dsIptVHr
         5ZFaGgcRK4iUNye1V7R/GoyRZAphRtuhOISAIPqwJvm9UOvEGQYNoGU888Ia+n5Wugxg
         MkhK8xvzCRH0BscRJblrrKy2fJxiZx3k841KqrBmQVSq3mW5fbsOBaSR205qNKFebv8M
         bdCz09yiqTCNez7Cq1oaPeam7NbRLB7L6P6hWu/aa+Xiql1+6wKOTIwOvCP4SaiUdWs3
         +AItR/cqmQ6y/XsBEdR43ZJknlwFiIAFD33OYXahtgeCvAYqmH6zzi1YKlXgcChnT9+L
         wSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206304; x=1744811104;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ7PBoGlhVnnicpr1k7pW/KHpPlcAjam6ElLxsZiKlU=;
        b=pyWSzZtN3i7sk6i6wVRgm0+Dv3KkV1ax1+Xcl0tGy3HEyAF0fnEO1AMvEGop43KL3s
         +ZP5W71hq/atMKWB0ajbe+vJNjvnZY1RRYOSSHnBRlJOqjFFF4uFyDzaMLz9hAX874p9
         JUoZWspFWaqPGWht9oEkIYvqIleXoWzBJYtxxCk7djAykSt+in8Rrq4wbXXmM3QvNf6H
         hExBEP8LljycMpMG0GPwQif3rbOer5p8iCtmv/wOpKMAH/PoFzXQzE8vAPGrUwOZGe8F
         ncAANpe9XMjuuXi2qiy9DJVvCZCzu5/Cif90PyYN/dYy9WVF7yKDVzMqzsfwKGy8jOZb
         xkfA==
X-Gm-Message-State: AOJu0Yy41X2y+Bvey42D/0AZXmtqeP2kTSPXg9gRgtvkxkGl82sEucGw
	kxDvw8lLWPJfv7OILEsmyHy2F0lvOgXlxJ8MKgTyejxyeuiPZlkda+m0vry9YYEEMvk0iEdBVKT
	N
X-Gm-Gg: ASbGnctrTZHnGAgt9bhSSbrB15MqXFPZuw0oWZQWt86nSqTEj6hMQOzUoTsFHYREhln
	uRIal0q6N06ULSzE/6pjE5mVsQEKOvgOKhZkY4kYzPd0me4fiVCp5cU7TX5Gbe0eYEgPoMK/v8D
	xIn2PJKtcq7lEYo7B+Ml4jzmGy20xuSuEqXB3O4bo7hFH+Bjs5EvrDMpFLMp26DVDCabUrQOA2Z
	dE7QWqkBd490X3nvpN3jr6zoIX1/4JUB62dEcgUcfb9LeAKD8sjnAZ/4RZNqljLsHcFjNZxUK9B
	668a6v7edIxSmORpbt8Jb5sNBe5imGE=
X-Google-Smtp-Source: AGHT+IG4s2DOt+NGUrNhxZXRiD2HggdhBJyfoFyN+PcAXuRaAOArrP3o6o6ymhOFzEq4g2LCFAxFHg==
X-Received: by 2002:a05:6e02:3045:b0:3d6:cc9e:6686 with SMTP id e9e14a558f8ab-3d7bda36711mr25531205ab.17.1744206304212;
        Wed, 09 Apr 2025 06:45:04 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2cbfesm240104173.105.2025.04.09.06.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:45:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0780ac966ee84200385737f45bb0f2ada052392b.1743848231.git.asml.silence@gmail.com>
References: <0780ac966ee84200385737f45bb0f2ada052392b.1743848231.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: separate niov number from pages
Message-Id: <174420630268.200173.10590547626179086309.b4-ty@kernel.dk>
Date: Wed, 09 Apr 2025 07:45:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 05 Apr 2025 11:18:29 +0100, Pavel Begunkov wrote:
> A preparation patch that separates the number of pages / folios from
> the number of niovs. They will not match in the future to support huge
> pages, improved dma mapping and/or larger chunk sizes.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: separate niov number from pages
      (no commit info)

Best regards,
-- 
Jens Axboe




