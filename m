Return-Path: <io-uring+bounces-11832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F05D3BE04
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 04:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 483564E3040
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 03:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7791C334C1C;
	Tue, 20 Jan 2026 03:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YsEuUj+n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E301223324
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 03:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768880920; cv=pass; b=Db+ta+cpPbY27D+uYG7/UAbT/PX51yXfvGsE0CfURDmwSVQPrCJE7g2r9+jI8SS2t0AhN9zgk6AwraIgUHk3f4YJ4c3aa4P2TRf3U8oVWsUyT/l8gQEfvzgB8kzUBQmatf2DohciDu9NGdEKHG+UqF29jBWkRuP7VMAEJIj3Otg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768880920; c=relaxed/simple;
	bh=t4yjtk0cQZLS6bEi2bgTKg1Xhn3XQvyeZtoE7R9Xc00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XF2oZcelouAhbdi0QfT/MMq+9M0xMTuZsc+e8Viv5XKCtcNiKV1RhF0r0LjmHTxuwCg0zSlN92xJsHNrqSvjBvesKfy7jEVihn43oDWZmXQKgJ8gITq5mWzKa8qQOSF9rChk75CAu47vyb/dnSMXreq1Kcc2mk6g/hl9ejqC/xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YsEuUj+n; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b6bfb0004aso6828871eec.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 19:48:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768880917; cv=none;
        d=google.com; s=arc-20240605;
        b=jfdRzyfhBQeF2WsnchBF3p0UcKd8l6EHCjEWGHNJmj8cWhXxDQAZmRuaR5rtY2w/mo
         vrA3WrfEpgRAECz4e5aRjjUewu9Qo9iqZxU1RVjrS3pngX/a6rr+jzf4F15/hLlGcoPc
         92pWiXxe5Ao0i5jrkMomQVjhGGpciakdoY5zLIDX2zYSiP6UDBbFhhDTuAJpie6AnUr+
         j6nclGDFuJLLPBJtyAlDsoiX3C/4YV4Mxrdhe3d6COJLoYrN9RFz/UmA553IPh6hXeLa
         itDKfr54ed65+YDQ0uGKv9DXemj3sHss2aOY5s1o4OopkCTFvwzIad32ZLD/+IBOFA5X
         C4Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=t4yjtk0cQZLS6bEi2bgTKg1Xhn3XQvyeZtoE7R9Xc00=;
        fh=iqQOlvEhBv7iAxAjvPZ7lRQsYWXMeLj5Ldbe35wJ/A8=;
        b=VGAmQ1l09XOMkw/fB8x+ONm2BVZRMvMHASY+FOnKBOpbbzdIaanwKDA7reebzA6uGx
         BVQCbI6EZamNkVKjClR83HkofEiBDdimGkJ7lJmEgM25GjBmTaTsbYEdwc/6+OuW0RwA
         PT4jnOULPjqv0qyjyk1jlJpwvAyXuuEse3OTLFo1oJ4CBVru+X5ybiYT9EGRt9FrZqeq
         VH8YOo1kqiUVxIJ3Uy1M3YwIDRvQ5tsg9MkzlFfmhqM8a1GzdX35u4gctP6vGB93VmpV
         H9VbVH8QzyPSf/3ujvHO7h9YE4+A2GQBhOjxmWXhZxc/K83N/mIjEB/vTW0B2ibhKgzt
         Ty5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768880917; x=1769485717; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t4yjtk0cQZLS6bEi2bgTKg1Xhn3XQvyeZtoE7R9Xc00=;
        b=YsEuUj+n7YqUIoTYEno39URj9oSlZZ1mwNLfFXAN3reNIihlvjBKm5WVBf3jmOnSg0
         pY35SwiOVczS8qYfirSev7miA9VrXASqK20iQTBQWrljUWiotXM9CCS+d/YRrcWHbfnP
         QTMFa/4WXwphIJMRnJMpywIuxq/xUk3DjKyuRUYV9DiY1LOq7bkW9Ncq3D0fG55H+E2A
         Q1C7OEh3l09rEip0nYqJXjyHMOgou+8FARKzeq3bexY92TrD8GeWA3JODWLDtAXt8feW
         6v/l8FqkPxLyyt8zCh54itDHybi3N606HSN342+xiHqr46WsMG6myyeAwD6V03TOcm1f
         MYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768880917; x=1769485717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4yjtk0cQZLS6bEi2bgTKg1Xhn3XQvyeZtoE7R9Xc00=;
        b=MugrVbvjUEaXf0hASkLt0po6T+RoMB0/Mk5hIZ3Z6Q+q7bNw2fnKJyGg6r5IDQo5fA
         I3RHMPbaW7LIK7RmPkXwsWXzjCSNdtizWXZ6M+nz5JxjZ/zZyDTz0+BvJbJcieehlZfI
         UT0ygdpcwKJh4rg3UHvzLG4O5UynBwHIzcBkcShicLCCuQSci8/Wg1mpE+Kt0PgY5hVA
         JdZ5D271lraxyu/dZSXtylD8XrnBWiyrWrOJk/rEWPYGty/9Gi4mfkCZAqLZu8e/f4Y0
         j1J0PsGYga58JzoGHCZBYPRJBVUVPNEN71y8LEMLn6lsld668ydKpTMyV0eRyKl6Y13A
         1Hgg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ7sivrGNFzj8NyC+ol0x3QGT6xS/1xId/MJVYlmaftPSqk1bFCTtqKjJ3whSkPJaFbLK739AiAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAhYGrGSELqPc+zjZjMKHVR8tg4411tm0C1Hrmkh4SP6yE8wCX
	pMFbxb/yupOWumw+7yZ5Sb7iTnVrBBm8txMyb5/jSgRrxYqlzOBmZ/Ru+q6WU76GWkuQSxGiBOr
	c/AZ7GbXd/5psWIDAT4r/enaMRzIyU//K2IsLpLI6vw==
X-Gm-Gg: AZuq6aJhpUhdI7fmGk95m0PUPBh38dTLkwWO57HsSzUqmsMx3UoU2Eav47Hu0VQhRrK
	jgYoHZw4e5rx2RDHH76d6ddJGaV+pu0qdni/HlgUHFShkdOmX9whUtQQkDwNOu/KAcOJjJC4Xf9
	ERzcFJLx7WFH+P98JvMMT8sRax/TDPsjw1oq2MWXnnAffiOqsRlSiVqzD0lsOGUF1i34IdcFAWE
	JwSCmXVw3Eyrc/3dDuV7cUtfdYJ07wKXz2RPLK697UMrDwtEGCTuibdZ5O4o/b744Vz4w8U25ov
	vUpusRH37IkeJv5egzjeMa5/IsqySvZJciXT4/TAuVfKcHIE+pQCZvQ=
X-Received: by 2002:a05:7300:6d15:b0:2b0:5609:a58c with SMTP id
 5a478bee46e88-2b6b4119739mr12115704eec.32.1768880917365; Mon, 19 Jan 2026
 19:48:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
In-Reply-To: <68a2decc.050a0220.e29e5.0099.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 19 Jan 2026 20:48:26 -0700
X-Gm-Features: AZwV_Qj0kT4YRIdkC-rKIxt8KBtEq4Bw-WpOaoV34hTsTNyFLWkl2x5CP3aI0ss
Message-ID: <CAKb3OG8BWihCKJdn7WOvQwZ8M8TrC35xjkG-h904ybgJN8w-HA@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
To: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
Cc: anna-maria@linutronix.de, frederic@kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

