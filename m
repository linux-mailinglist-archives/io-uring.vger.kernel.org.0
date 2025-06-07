Return-Path: <io-uring+bounces-8277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0FDAD0AB1
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 02:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A216C16BE34
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 00:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA80D531;
	Sat,  7 Jun 2025 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="V7Kwdf13"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E42D2FF
	for <io-uring@vger.kernel.org>; Sat,  7 Jun 2025 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257372; cv=none; b=AoDowj1V/5leniIDy7HHlNjUFDHZSmfBb5d6f5un4BdU1nOB4nV7BfsO+z1fjQHKgVzmLoIW+5VI8lw8cWE20BIeOZ/ueMCJJgbc4EXo1FeuXnzLwjKagfbBpC3p9O9va5U+KHLo/J1U2ELp7cmYf+eHFqh1tur1wjFvkksUIt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257372; c=relaxed/simple;
	bh=g/8QWRsc6dT0DE/18Dfa0v59hzk5stOPknWkc+rK6F8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=br+I7yEOXOy5ChvfjEY/rc5ZIM/JyOAEwH3BESameJQ6jVgXwvdx6+TVC6e3b6vvlzOtA7vtaum8mhcnGo6KpfsOMB3ahUMQ+wYSRpoUPxB5RryGHwYPSAeCWhG1OVZIdZQH99titUcYD5bUq5SH63I2+Qw520lz1V9dY0t0PcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=V7Kwdf13; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-311f6be42f1so411501a91.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 17:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749257370; x=1749862170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/8QWRsc6dT0DE/18Dfa0v59hzk5stOPknWkc+rK6F8=;
        b=V7Kwdf13YuQE+keM+qV3Y0uE1GNkScsi2gBSstK94QB6gshOg1F8CQRdNiqidqDYFN
         qMWatsiUMdUi18li6Yw3qhYz2C3jFaQJ2QlG+Zf90f7HCnYXObBOQEy0mmxvYKjjvqS9
         g69jWBV1aR4qA7/vuzHq3ZXuv+CUO3+9hostKxCTvd6XUSPLsOgcsPjR4IsgNyQb7jr1
         qmJ3O7GTkvC5dIGikcaE4o3h7U9ajKjoMLCcs/2/YTC2BF9E93lQe4XOdAFkwvgDzTAe
         2XjpYSSjlJb27YJJJh4ZIU7PE0Gj8O9SlCAoIY/MC0L7njzYOzO3PX9Qe6OIfy9GONUH
         G1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749257370; x=1749862170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/8QWRsc6dT0DE/18Dfa0v59hzk5stOPknWkc+rK6F8=;
        b=pJnR8kYLlM4gvmkOZ6kB5tzbbn3bSiFu8mNWV6dUlOdImXMpS+EfZan6Y1aXL+F9P8
         IhEPNGO5UOeVBYb3R4i0whwkKTw+8/+Si51DLTuEIZr9sQKncSxYG8QpLlGKqAFAoNpR
         obXm6mh3fc8CzrTVZNvj/w8q5QqACm9u+BBvpvK9MUPdp0ILTNWqY6fLWNTjjynbAm2H
         /eZKHp6IsXJx8gYX0rn5XbiX3Ma68cJ+Iy6D4b+CUjA/hkp+2G8bXHjTm6kBN52U4jje
         ZU11vrkjgylTeqOopFdhe21/OCdoER6VuBYX7NQIfKxMvSQnJNbEGTpAQTk74UK1LtQw
         mAqA==
X-Gm-Message-State: AOJu0YzqupwrV/XvXH0RKXLQ6oMErJefWR1lSIGQ0RA0CUOkQM4mQhDw
	Ip/6EM8gO0TQZRaetkGQaf+/4qyuRdVdACTmf8l/pxBQ5EgTbFlx0yGtPtz+CENTacGmnL9ScN7
	vXf4dO3Q0NC2TRZzxG0JHfMNdZFPUo9KZBs8cyitjQw==
X-Gm-Gg: ASbGnct5D68Ma9QmGNWI9bAyqPITotKIVOa2O3ibMM4C6RcoEDwS3XyDRwZCJFLBz9y
	F8RvnC/kHbgvxT0z/vlEeFpr7U389plwwvaz7OolF6ZFfZbf10SJLJE/YA7Rqea51vQ7eg90gPw
	x3CX8OLWSzusD8zsvEYePaX7eblqiJ7OZR
X-Google-Smtp-Source: AGHT+IHzI37W+G1A2Yno99ZJrybwJGuzAC5/wz2+z7L3XBK8uC7lBWD1sOIjWUIaQLrcddEGRxPQNYiEuc+1Jz1qoxM=
X-Received: by 2002:a17:902:e544:b0:234:bfd3:50df with SMTP id
 d9443c01a7336-23601d217cfmr30484895ad.5.1749257370202; Fri, 06 Jun 2025
 17:49:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606215633.322075-1-axboe@kernel.dk> <20250606215633.322075-2-axboe@kernel.dk>
In-Reply-To: <20250606215633.322075-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 17:49:18 -0700
X-Gm-Features: AX0GCFtPxjkhCsfQdDGo0lxDbjw6O-VHnqEfzfdmuIbQ8RIK4dTUhRFceninSHk
Message-ID: <CADUfDZpzaXKz70bpVa6i5_Dc-jMhqaGWxgnQuqs7uSz8WBsncg@mail.gmail.com>
Subject: Re: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 2:56=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Set when the execution of the request is done inline from the system
> call itself. Any deferred issue will never have this flag set.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

