Return-Path: <io-uring+bounces-220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59924803DF9
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 20:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A8241C20B0E
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821562E854;
	Mon,  4 Dec 2023 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fEn/gNwB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A68183
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 11:01:41 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-35d374bebe3so3562345ab.1
        for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 11:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701716501; x=1702321301; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KModFUjISk9lPDaAIevH39bme1IjL/Al+Yhj9dt8OqE=;
        b=fEn/gNwBzsj9hPZyeuCHK4lnDL2SsAnAFWwQdtpww8QUS/aCdJ3mu+JAzcfZ5JajQN
         BECuAlkfOdpOeDq7Q8e0eCs/whnYjz+KwnefATNfj7R9JwEyi6QiaGWX61fxgLygRL+R
         6NE7ehHB6/RvojDU6/8lgc0w6gSGmejRcwYkBpQYFiceO6E4O5JlCeFxb2sx+z5V8kE9
         iQXseohEzgvm5vj+lkC70Ztq1frj9hitpVMpH1rdbP0LHrABSvjFbcU7vrKmf/2H9sVz
         zmxB8nbZRMnM0YR/DKG/A0jZPCeA9L8vAJsr25cM5dfXl4AI1qZW3X0GAoO/lxmyIrPT
         Pf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716501; x=1702321301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KModFUjISk9lPDaAIevH39bme1IjL/Al+Yhj9dt8OqE=;
        b=Y2qWZ8w9oQZe1Km3h8gGUFEWTUJXZYldJmgprd2idHuictDmqP6FW3ATi177AVBlgK
         zSSiOrx3+RYjh6fE9ezxZvXxa5xpItxQO1tZmrOO1Uzvd8BONdEUrXbodb4hYNCa6ynM
         OEUkaZm0vsrkfzvm8OGM+QXorJo+vwG3NEi6K+v8zGFZeB4gM0Xdpc8uU6Yy8WZ3sGiq
         ldhZhzB+8gD9L7ihTS9/Yt1HAllwvjgvRGVOXExisCXvAeCrxqdZBw2VQlqOg9sKRMRp
         OTZUw107JRlXedlXiXoG4xkq+ioWdOr2EIOJVmgm1nyt40zZqykiZ8h8jjseKXy/oP2Z
         R9jw==
X-Gm-Message-State: AOJu0YyIOVIq+gd7koG5pl+jv8muAK/XK86FLbVdlDytjaLy2mKRkc1L
	EWFeQUzsBOEUaFMF6pQZcRQuOQ==
X-Google-Smtp-Source: AGHT+IEt2MMR+yxdjujJW2KLoxn/yZExW+eo2d1nv1y7A48SjFpuY0W3NiElWjAJPk/nnbhIfFVFZg==
X-Received: by 2002:a92:cdae:0:b0:35d:607a:d943 with SMTP id g14-20020a92cdae000000b0035d607ad943mr6603235ild.2.1701716500958;
        Mon, 04 Dec 2023 11:01:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h4-20020a056e02052400b0035cb655bafesm70728ils.45.2023.12.04.11.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 11:01:40 -0800 (PST)
Message-ID: <9c1ee0ee-ccae-4013-83f4-92a2af7bdf42@kernel.dk>
Date: Mon, 4 Dec 2023 12:01:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, io-uring@vger.kernel.org, hch@lst.de,
 sagi@grimberg.me, asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>,
 linux-security-module@vger.kernel.org
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49zfypstdx.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/23 11:40 AM, Jeff Moyer wrote:
> Finally, as Jens mentioned, I would expect dropping priviliges to, you
> know, drop privileges.  I don't think a commit message is going to be
> enough documentation for a change like this.

Only thing I can think of here is to cache the state in
task->io_uring->something, and then ensure those are invalidated
whenever caps change. It's one of those cases where that's probably only
done once, but we do need to be able to catch it. Not convinced that
caching it at ring creation is sane enough, even if it is kind of like
opening devices before privs are dropped where you could not otherwise
re-open them later on.

-- 
Jens Axboe


