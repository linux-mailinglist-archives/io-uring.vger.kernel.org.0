Return-Path: <io-uring+bounces-5566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4489F6982
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 16:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 176E77A1763
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 15:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0056A1B042C;
	Wed, 18 Dec 2024 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DW9Nw/rc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7FA1E9B18
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734534549; cv=none; b=TjsN8EgkIhw9GVh+TmzJEm+XC6PX/UgNyTofGyPx66lKWw8ey8VZ5AVa8wf1if9/9mLKAMWzzj8o611iTRUL0I1cvd7Q/zKAdriP48fmSKUiWs2/GjWmyu/vhEUnRLUX4cvgAOpnoxL+mCAQC2IqIwggnOD7Z6R1ibn8l4K8KkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734534549; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eoPtTBOpPjWYT8GAuPARMYJv35DtxCXMcUpG6iTBJVTBhTPlgj9l/KMXv1iae2rDFTtMPL43x2lsmnzOSTok3TuDELGJdhD0djyU7gKfgzItjO8fB1Pz8DBoakGC+oJk9FJUQHQQGg1iSjZ1MNj0AkwSRceMdRkFlr6zkF9qwoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DW9Nw/rc; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d3d143376dso9567004a12.3
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 07:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734534546; x=1735139346; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=DW9Nw/rc/lu8ZMsQ1u8RdYfXfx+dZZu0l2A8mj6dFXnUMM4Hdqz4LFAFJdlY01FuVI
         Futoe/GGk69Uen//MnNTcVGRs7iz+ydPFjR7oFdM6HBexhLXUA4XAUhN8p+RnxNJl/HN
         9xgnArTaWCHGfey3LsCTdSBhCyy15oL3VfEBSsOFv2xExU8M7nLXOjdwv5os1FrJId3R
         VnEZiJ1D+Z0y+ThVV1tBcq6gK4ulYNRhAzsqOprtf7Cg4v0IGByAm1ow4abJjUK4I/UA
         4dX8HDeURlIBMnp3OoaXgfYUqT/s/LaPqh12DntB80iH1Otbcg18bNiudoGgx83UkKDY
         fFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734534546; x=1735139346;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=p+wVSBVFkDEY/IXby1iDdDhNQ9xzDBx5BKesRc6biOPat1azKrP2FFZwCKqhSQ5FMN
         iEDdWne0My61aNSnz5bLvbzCTxHvPHprcMGnkTlm84Pb7s3zAZFvi5IBAJ5oTjn+pLH+
         vvhXLHe99xunNGy18AI7RttoTe4eXrCRVcaXFtoTqisBA03BQOrOnQIFnUprwCFYPVxQ
         35FMhZx5RcX0TGWxJC2hlneVQApQXQUrfFaRR9BeRonWcEDqpz29iMW+8n/YDyD01qoi
         YNCzcrIsaHHUdiC94f3l/DWg/ZNZVijtKnjYng/W9TGzx4r4fbeucLmG9VPcizB/vrDT
         4EIQ==
X-Gm-Message-State: AOJu0YzR4OxYktNj5nrBYzsATLzgF3SWGu62HnRoE13cW7bqaQd5bM6t
	VmxaVN2+d0Dqt2vu3Yt51DTLlu7uTRGYJ69647GR11EUVgv7L+WiOnyvfl94efJomHWnQ6ewHtB
	gIdN09ScQE+uqlav4wPnOELheyw==
X-Gm-Gg: ASbGncvWjAa7SB4OoetMxMk0W6eaJKVNlknkt9zht+wFQ6KHQK5cUTIOM6AMNw/RsL6
	v6owKFPbQH/2Nc5F6dT7Yr7giAk0hthDz7p0GDuNLLG35uy+lUzRPhHARwjWtwKIwsvWc
X-Google-Smtp-Source: AGHT+IG9a/zbuuGdpaGDuP35Qv2+2+CuxU2uOdEZ32KKY8uP4Jlxz0pazxLCc2ytAhCCSaw8kH3doU9D40L6ekOQvx0=
X-Received: by 2002:a05:6402:354b:b0:5d4:4143:c06c with SMTP id
 4fb4d7f45d1cf-5d7ee406095mr2807527a12.23.1734534546161; Wed, 18 Dec 2024
 07:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <987219ec-d6ba-427e-a9fa-9ac63660bb72@kernel.dk>
In-Reply-To: <987219ec-d6ba-427e-a9fa-9ac63660bb72@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 18 Dec 2024 20:38:29 +0530
Message-ID: <CACzX3AtRrembs8si4ConjN+tPTL2n7eUeeFtiCAVEFqHn5Pm+Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rw: use NULL for rw->free_iovec assigment
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Gabriel Krisman Bertazi <krisman@suse.de>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

