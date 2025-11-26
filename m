Return-Path: <io-uring+bounces-10819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E6DC8C19D
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 22:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C6113B194C
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 21:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2375131987D;
	Wed, 26 Nov 2025 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y45h0uaa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EA52FB0B9
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764193652; cv=none; b=TOO+Yj3WfoT7h9zyoJ6shi3+Rnvd4ikjkMrMjU18jNcyms4UaOgLwOB31VyHL+43Kp8SNKhIe43CYAO9QappXYlZeGsaue4MvSI3h+rwg27FdGIFr0qaqMJahnQrdruZ0R5Xe7oAeQJpVctzojmFS3dIpayiEtiYIDHWemHRcoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764193652; c=relaxed/simple;
	bh=aTRu8ehaR8C9IbfGge+yugDPQ0JoxwO1iOpUQZjfELk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S6wG1MYocAY/TQo3HaUNKeU7E3OhWS3rEwzkG8IyJICHliX1+Jh/eJLcxq2/8EPkG30oOgdsGEzi6O/s0zmqmpXxJabfBqN7nArfbC0i8XbAHAhGeJK1gB4GTAlRNTuECV4MaweBBnj+R6O0W6pE+9ajNIxPUInlad/+cDX1mVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y45h0uaa; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-43380a6fe8cso1468465ab.0
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 13:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764193649; x=1764798449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRMSFdD3voxfx4MbjoadlpHFmNXjrJGlXbs9DFjlHxk=;
        b=y45h0uaayayIodmP6XzRwDvWGICm9tHbcwq6P00vz6+UVM3lhRR8uOSQAVL49K2eTz
         EE3ahRieaFpHay6tIR07nUe8DJ2aSIWJoNlTwZVC+D4jkWyd5nBz7lcbXETwBnXNVvH/
         qON2/OOOjcJr9KH/mgkYlfDcihooJ+12G8G0VlTkmx7MQhL1C/aWTqHpw++Qwp8PgsY2
         eB6Rx6gOBfr9UXMJKqhnA+q4E+WtyxmfQjhbQtaHadoBK5/sUptUhDFl86601z0USdSB
         IunOqIczN8TuGFdvXuEnUZjg1cp0GrJI/VlPjtz27EgJTzKSS2CJDMnkw6Qz5qdna9dA
         EF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764193649; x=1764798449;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tRMSFdD3voxfx4MbjoadlpHFmNXjrJGlXbs9DFjlHxk=;
        b=Jdk66EFvwb4CQb3Rmmr+SiunOqU5tBAWUH7Cq6fs3d0QRkd5go2bbFQKgH82nXYlAq
         AyOKAzvXIFea4YxRK6EwxOZRKkKGs28mZ3dDW6qunOVajVCm3QebEInz44iPSXUEOX4U
         6ZLcGgL5N7YeYsWRSpZ1veKlZx+joVGXfkI1Kt+RQEGNJo9JAhDuNaPX/eKgMIfl10Ds
         w0NT+K5U5kXwTfw4kLb+4CV3ltDof9Mp+5zGxwFtGQy+uPb4AwND07eOhqLjbcGwzwfT
         0defpV3JPbnUiDtTEpBtX43sY4QSIJyv3PF4g4dSjC87mKoxcWlwQMTG0C5e8xf0beCZ
         9QYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA18PSXnm3vi0AM10Mk1NKStV6i2cMfOY80cXDm/FtbV3O5fqltjf0V/0uD0sJqn2LuYwvAYAOZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfPK0+kJ2gyuvXZTC2F88GX6xK5bN6tGA23g3I5Ea4hpFfvoTs
	cjLHL1KTd61M7yj8mxhDQ3WAVkS1UQF/A1y/TzqrQVJ0J3uyHorDDADIZdWRdiJRWuA=
X-Gm-Gg: ASbGnct8VMn3mY7BuftmF8eBYk9XUuxLf/kQRSfe4QePdGfQcNsY61owTBYN35rfgu2
	rkie4duWMfSKWaYklR5IonJ+H+wcVMca7KaayIdu9CfIQjgpD7dBPylH+CzFZArrFMBG7SIc6Ty
	bcqEtj2gcjW6mApRrXEUan4SF+++SNX4O7oKhqcxjbFqf5QuEwhrL5sQt47ZJp21NMOWqxpbByO
	NG3vB08wavNMyWj1BU774q1CtRw6A9331HgIzbXczNo6wNm7kmoRWadU2waz29RaMnLbzqQnI59
	sWRzVjg+tC9b3nBmpWHQ1GWqo+B6FO4Y92uhHBnsPymjrwTLj5YOOpnHMqZwOKSnhUqICzTH3gS
	Wg8GNgKA02T9kKE56oIVMaEmn6GfYoRCzbXwNxTDINA5Ru39yUn9uXhIV7XuEJsY5794+T/gd2B
	pGMA==
X-Google-Smtp-Source: AGHT+IGU47APB8HREWIKQ7LHtSHQtH0WfWDt2UiFu0qyvc104A79dIZQ3hb8dByyuC7xO0VIA6MWyA==
X-Received: by 2002:a05:6e02:178f:b0:433:7e2f:83c5 with SMTP id e9e14a558f8ab-435b8bf921fmr185781495ab.3.1764193648863;
        Wed, 26 Nov 2025 13:47:28 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90dd80fsm88697115ab.29.2025.11.26.13.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 13:47:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, 
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
 Simon Horman <horms@kernel.org>
In-Reply-To: <20251125211806.2673912-1-krisman@suse.de>
References: <20251125211806.2673912-1-krisman@suse.de>
Subject: Re: [PATCH v4 0/3] Introduce getsockname io_uring_cmd
Message-Id: <176419364754.144810.11021762259652723492.b4-ty@kernel.dk>
Date: Wed, 26 Nov 2025 14:47:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 25 Nov 2025 16:17:58 -0500, Gabriel Krisman Bertazi wrote:
> Since V3:
>   - Fix passing of 'peer' in io_uring side.
> Since V2:
>   - Move sockaddr_storage to do_sockname
> Since V1:
>   - minor style fixes
>   - Resend with (more) maintainers cc'ed
>   - rebased to axboe/for-next.
> --
> 
> [...]

Applied, thanks!

[1/3] socket: Unify getsockname and getpeername implementation
      commit: 4677e78800bbde62a9edce0eb3b40c775ec55e0d
[2/3] socket: Split out a getsockname helper for io_uring
      commit: d73c1677087391379441c0bb444c7fb4238fc6e7
[3/3] io_uring: Introduce getsockname io_uring cmd
      commit: 5d24321e4c159088604512d7a5c5cf634d23e01a

Best regards,
-- 
Jens Axboe




