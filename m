Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DB21F6BAC
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgFKPzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 11:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFKPzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 11:55:37 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7CC08C5C1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:55:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g1so4282087edv.6
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:autocrypt:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=shEb8Q2+kyReiibTRe10c3V/d+9/B9AMcoKf1MXWrZQ=;
        b=cLeHeOF0fB7gVCeAlCFsgxIAU2Yh6paHr5QoDkZvUAcay/VazLBVyl6Nbn+ywGvU/x
         YgmYikxKydid72IZ6I0nvYiZrG3hcedw4Y6dZPXt82wlUN35EEpJ7RuGMidERzzMa3lt
         JW8c27J7uZLfGMMNPkDHnHHobpb9dP9ph1JBwpgU3ayrcHYoKDuzODaYizqYigBtIr0f
         W2c/O9k+Tlwr2bg8ryMTYHOt6dldsO+JsOej1A+S2REdOGvh8A/zhsBXwwWwjewj4Ssv
         4kxTDr2UJC383sP4C1Qwqxjal/SZVJnyujtTkMOwhFar96mudGCiamOrzUSJAyT+e8nW
         d1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:autocrypt:to:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=shEb8Q2+kyReiibTRe10c3V/d+9/B9AMcoKf1MXWrZQ=;
        b=XntwW2fdrk8GYwEKF8wVArSFgeta2N6VQGUnf1Hyg8vCgVfVuq3TtfBb5Kkhc5HUMP
         0FNJQE3mf3vhEq/31pcx5pkKcs121YCnhWaP4Bt4ozaNz57MzefRias3JHz045mGwRhn
         DdSkr01AIUjK9XUJFwtazdPOyyzE1WsEiqA0v+r9Ka5J7k/onHDdnjwz+BzU0UUsrNC/
         Mm+/B1VDfMcx2qXrM9mnkEYN84t738wGsLfaPs+K3+Ln1xo655XZ0GZ0B0CsMrM0m7WD
         k5/2W5JsGXjNirNIyNi5CkM+4JQqzoudSAfX45NYOCT5IQeuGZN8G40R66YNIU6bD/7Q
         lSMg==
X-Gm-Message-State: AOAM530Hg56zPJn3GI1b9YqHLn2CTcPoEgrW72D84leuKfhZaT8fV34F
        wtiRX1T4UOet7bPrKUQtM/n6Vb4b
X-Google-Smtp-Source: ABdhPJzSYD5NwPJQ9E0Wm/UrJRTqoZPgMoKlpxzc1xx5+Lz8qlWjuPNXq/fO2GFADSo+cyQWm6JXnw==
X-Received: by 2002:aa7:c598:: with SMTP id g24mr7787209edq.132.1591890935611;
        Thu, 11 Jun 2020 08:55:35 -0700 (PDT)
Received: from [192.168.43.17] ([5.100.209.134])
        by smtp.gmail.com with ESMTPSA id s13sm2086405ejv.29.2020.06.11.08.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 08:55:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [RFC] do_iopoll() and *grab_env()
Message-ID: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
Date:   Thu, 11 Jun 2020 18:54:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_do_iopoll() can async punt a request with io_queue_async_work(),
so doing io_req_work_grab_env(). The problem is that iopoll() can
be called from who knows what context, e.g. from a completely
different process with its own memory space, creds, etc.

io_do_iopoll() {
	ret = req->poll();
	if (ret == -EAGAIN)
		io_queue_async_work()
	...
}


I can't find it handled in io_uring. Can this even happen?
Wouldn't it be better to complete them with -EAGAIN?

-- 
Pavel Begunkov
