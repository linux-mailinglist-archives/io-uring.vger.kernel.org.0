Return-Path: <io-uring+bounces-10807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 001EBC87956
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 01:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE61C3B2EC6
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2E81B4223;
	Wed, 26 Nov 2025 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0otr4jv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D6148850
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 00:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764116662; cv=none; b=oKQa8lSFbD9sj+K94PVWOE1L8InqgBbteWfdq0VuP+/csudyIrsAI/i7/PF3AhE80nqw5fCmkWCgFX4QfT9IN9H7qMRKCi5rsYkHVYHlrLHuToTg+RUvxw4aFfuIw8AIeY071+eGGHaZg3GpuSWPDAtoPErI93rHepYCH62NKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764116662; c=relaxed/simple;
	bh=bcfV/h3aH3+Ozbq5WoP2IHNx7zN+IKQLGmHkiAHzNb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PvUNJ38IEBRnVDKJUt5M8eFUtPyoYZoCSEQkIu9mcSHcVWKXEsdDpDifJnCgT+RF8rR2G7Y26WsJ33NJfLg1ORC4ugx0ZxzeJU7WS8X+gjBUKE2CCLf1BSeLHx7WTmUs7Ezxg8iaOm+gAO/TqZedLfVf0Gcjb6SokTDUFTrqRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0otr4jv; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b75e366866so2849201b3a.2
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 16:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764116659; x=1764721459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcfV/h3aH3+Ozbq5WoP2IHNx7zN+IKQLGmHkiAHzNb8=;
        b=F0otr4jvtyU1Ai9qv8P4Gn/CFdXp5q+mv01B7G5s0TKQr7PLJDa9U5cbh6h9bRiC58
         l5/Vlnadof0lX9y2nmd9kjlTXibeitIoS/qLaAAxbguYIOMDcsAN3rQYHU1p2+5ZXQSK
         ABsBVI9Lel1eN+L0sZ3DZOFIvU43e5ydS9YzmpLZg8Q3/km3MqDqNDE5n20r+DCbU0Zi
         UDPtzs0J8Uljp5vt5/trmKmlisbJBwSo+LBlynwFWY3lv5WLlsk3KNztBcmObs64IOE7
         pUybbp7oA1PzGhiCxOLeBy6/Y5lzyx7v1K+XeY38WXLzGBUVRWcUAufM28IEqpd61G0d
         foAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764116659; x=1764721459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bcfV/h3aH3+Ozbq5WoP2IHNx7zN+IKQLGmHkiAHzNb8=;
        b=oBlck1aQ4OMqPhdJuLQvsSvRhAY2DLs3IDsRn59JUqEui3Baa5OPLJHNfTZMApYVNS
         ulaOnn7sU7swmdR2xqSlfpDbM0WGCLoJYX8Zpm9SHcpQQ4ehey84Hd18vrLh2ZpJ3jAh
         mqZPE5LP+AUSkJ5w0jCKZo0M/wNPfTBu+qV2VvtSf3fkvSRVl6qMmnjgi1am+TkDH1eA
         ndx3Rw0DjyvMZBLU1rGSWJV5DhijCkDqKXImt1o4jBM0WuzfEg7rstI9Za/m1qnZd7gZ
         04hudcELWfWnoafBR2mUPEx5rxEIc0BtINXlaUaQxuzyQEIRYaIamt6npAx39aMyn/W/
         qSRw==
X-Forwarded-Encrypted: i=1; AJvYcCVI3Q31veS4Z7B0/bXrBJuL6WWTgJ24QR9PpSbbHxudoof5/AM/00SBv8/WL5zX80GooY1JZFXfTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyoy9wzl+1RH547TV6NBGpHIK6cmrZRYJiBeJiN3QNRcQLrICUx
	Y11kEs2rqTAkC0new/W0w8EKxzQfajog9Gco8uFyt3AqI7PM0LJrxn9PdJIupYocdPCqPNOLsgt
	4ClYDJuEPbUhofl9o7bqkwln4Q50cPs0IwHHync3D
X-Gm-Gg: ASbGnctJjbyHwiRDncNfRd8lgkYcIv+iO+mIuwuElJs4HOKP/FvMWkP+8V8MTnvpKGl
	syNk4baWoyTG4qj9qEpwvaX0L4zRjtbBU9hVkyyBpMQRC27qXSp6rv/p+GHmV6RWqcYyRX5M7g7
	YEVwKDu32scHv5WAKe1UYw+GQ0zv+o3oFpNKpEMnoZMXQQVL5Otu5olti9jhAqV9qV2uwTuhogb
	g4m/qSKG6vZ1/fwoYJ117q31GPQKvhd8bLppbHoDltSkGT2sHxLa0Z5SNJdOaOXSy7Uvzxio+fy
	DvciYN/2yCYxUkO2l3eIlkjMW9pMIO3sfuebDKL2RI7trUfBL5YyY2MH1g==
X-Google-Smtp-Source: AGHT+IEDlAEHYuVsPWLsYFGEOywEpmYgazzOZ5ID6ttyxEIwU471kyHEToWhLXKitrImILfpwMqCYETMRyOK4VTWFRY=
X-Received: by 2002:a05:7022:2389:b0:119:e55a:9c08 with SMTP id
 a92af1059eb24-11cbba6ef0amr3879981c88.36.1764116658851; Tue, 25 Nov 2025
 16:24:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125211806.2673912-1-krisman@suse.de> <20251125211806.2673912-3-krisman@suse.de>
In-Reply-To: <20251125211806.2673912-3-krisman@suse.de>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 25 Nov 2025 16:24:07 -0800
X-Gm-Features: AWmQ_bn4XUfWJ5BaH-_XGl1z8zK8dtykaSXnqp56s7Js1e5rh1hf1C93Z6Uti2w
Message-ID: <CAAVpQUBj5q=nq9GaqzEnkygEuSJKX+sm4GMBuTKQUXi_33gifg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] socket: Split out a getsockname helper for io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 1:18=E2=80=AFPM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Similar to getsockopt, split out a helper to check security and issue
> the operation from the main handler that can be used by io_uring.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>

