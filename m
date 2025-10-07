Return-Path: <io-uring+bounces-9915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 811E6BC17D0
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 15:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DA6219A2EA2
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 13:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39772DF159;
	Tue,  7 Oct 2025 13:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Eab+htxr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738822D5C97
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843475; cv=none; b=Bqgx+UngyCoEbr3thxrsalU/7cW4asPJ4gs2mOlTZYaPfTzkRETGQyMo+dGkLe1escVat2iV34nN1+3Mu24W3DwNfe6ljzhFVYUopn7LNzUQPaxxeibh+n5JUpiiKqJS3z8xGyp58KdVHvf7wGdSdboPViBcAOYHwnNRZ3v2N3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843475; c=relaxed/simple;
	bh=bghomkZ/Mo0/sVWF2FY7OF/9Z+YYexGj4hCWn+ZCfag=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=SguoSLLqB0PizaqeeHT05KrbDKMm74FJdwdFWiDHV6HER05fCOr6oqAu8QMEG1HwAmLF3Mv7FikaG2eFaPgLe7NLWDYIq62LGdfSZOaZJTPZlNWHDK8gLjdCmiE6F5a5LW/qAv9raeRSzeKxoc0v+T9nwraWlqyNVR/w+m7UoVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Eab+htxr; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-42f5f2d238fso16584715ab.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 06:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759843473; x=1760448273; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WweNkwNQjd8/1NMfLt34sTeCfWxi9H3dopa5H7gJ+Y=;
        b=Eab+htxrZZcD49PvCXlUSDYx9pLRRzSg6ctYn3uN4ZbRo04ptYBZ83cSQEcpshXD7e
         9xb4/fN7yxNeXN6LVtCdg6E4U0l+/xJY+ih8Y4EHQ9YCdPFl+/SnK9KrTrH/eOTp/SKM
         siWoE+P46eOTct0DPsDpz2XlSUqLMu9MArH/wH19xn+owuQYIRlE2UimMT3WIn1uC+4f
         nDJKBSxdWPsoCBGmRQTv2kK9YGQn3pauh5PuzLMd0rOJQ5EneVKVV0QowfkHAIlifB7o
         jh+h5qxp0TTuZDjbdhB0s2Ajz6HA2mDAP6UsrVHoG/4eo1q4j/ysgyzTa0IpLuHWnetf
         Yv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843473; x=1760448273;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WweNkwNQjd8/1NMfLt34sTeCfWxi9H3dopa5H7gJ+Y=;
        b=kLon37F2iDkVs0aIyMEmOn30X67LNKq8qgp8VVOjg7jE499Q54DxAMYU3QQCHVtxur
         w0zcsWUoTBTh06yoRXEQD0iUUc8ebI/QvFORJp//BK/ku1sKGJ4yH48ZqgM98GwywSw/
         HupzvgCL/7laEjrECf7Zta4VJkgYXvibN4wFpTVD6KuS+Uyc8/TnDsMKpaO5Im3gxd/Q
         mYDjAHA8KIndeqhKO43nfFfvmM36DOTtLAYkhSwcxjC2QVHLIHW+z0m4fsllee24nZAD
         4fJpMSKCI9UmTap99/yjAdHU+fX6Qa9UKmbm3WZPMKGiudEcDz07KNPpLnyWn1vf+863
         jw9w==
X-Forwarded-Encrypted: i=1; AJvYcCXV8a+iK814lkbgU6wu3y5iE03zbh3G3cSRPe/DW25dvH+ifu/U2s170LBxIzuPzW5pGyHNye8V1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4of2hKSxiPPW4Jaiqi8+LdsQfArHTUpfwFgDzbOtAEEZtFOwg
	H677uF516F8HH0Hc+W9vrFofQllaupxwQ5D+e+p2cLmk4svuxqfzvVq+UQF2l5+206I=
X-Gm-Gg: ASbGncuxX98rkjxSRL02Z+PvtPCqZfBh7LiazHhNUCw9FM2VSwQDjU54BOgKJcQAqrD
	08KWmk7Kjj1kyX49lAMIsCWEJqkqqssvfN8bC9LeT0TrmU/wltew3dCPBWMfGEfZUlsFTpvpcbX
	O3HGPqokpjrPXgW+V5+aZBy5YXvwpwMIDhmFXOQGkt5TfQPrhJ2iLyhGgApl5U7kfpm6Y8iuFip
	XVFO6umy7Ld41rQ7ej8K3tAMtgRI415kReayTiO9XQjW4pSDYZTrOescCuuMY7fvDotRqfWdpK4
	U7aQ+hwXAp9mabzJgAzysneGo1Rw2FruAAwZWOTLDTwgKmJJW250E1SkedwCRFTJpHqGAIyeLK0
	yqlljdnuVD97M7WB2Qg+99q6484Z3GfSnORVzAVw9LYnfwDvXU3HdvLU=
X-Google-Smtp-Source: AGHT+IHcWl2NGaXs3tOeNLLuo2dAOE0d8f54gCIAKh8ZkAGoBlURwFGuC+CeUxZJtomkNZLSqS0sfw==
X-Received: by 2002:a05:6e02:1a8a:b0:42d:7e2c:78b8 with SMTP id e9e14a558f8ab-42e7aced6e7mr209520135ab.2.1759843473392;
        Tue, 07 Oct 2025 06:24:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea3132fsm6092368173.26.2025.10.07.06.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 06:24:32 -0700 (PDT)
Message-ID: <747c4bf7-49bb-478d-a8f1-c7092ceaaa81@kernel.dk>
Date: Tue, 7 Oct 2025 07:24:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_waitid_wait
To: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Content-Language: en-US
In-Reply-To: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git master

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 26c118f3918d..f25110fb1b12 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -230,13 +230,14 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 	if (!pid_child_should_wake(wo, p))
 		return 0;
 
+	list_del_init(&wait->entry);
+
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return 1;
 
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	list_del_init(&wait->entry);
 	return 1;
 }
 

-- 
Jens Axboe

