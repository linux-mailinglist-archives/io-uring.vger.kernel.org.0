Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7F774501
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 20:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbjHHSfF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbjHHSer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 14:34:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B129C1565
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 10:58:26 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7748ca56133so40893139f.0
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691517505; x=1692122305;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/w2FPj8hkvrmGq+O6G7luRrBsz4G0SLRfxtnrA+OHNs=;
        b=AasbcmtdOEfGbOfZ09mB201dvfBtriGDq4msxnGW4Mq1fROkFPNzIkrRZQA8tBTlF8
         G7wzwkHVdyvWQJFlOOTqXpOaP2Iyg6/Nvz/eZ1k2ngk8a9lW4DmkxfunmcdkRZS/oexV
         b/h1SBWfJiJiQ/NcIWsCDJdJXMYjCLL4I+86qRg2s7F+gx+sUKnn7AmvDKeM+L4MS9Rs
         lLQktIGhjIPf1lsQoi0HKnx89jGAVFmT0I1HEOCoVm41FsTXPQ8bsza8q+jqbd+HtENI
         ZZ1tbPQBe/fo8oXpT0+ZfVlBKEAhwc9sacclW8QisYlfNMjgkTBkpSsWRlY+BVmqVmNu
         E6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691517505; x=1692122305;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/w2FPj8hkvrmGq+O6G7luRrBsz4G0SLRfxtnrA+OHNs=;
        b=OloT1XfBpM4dY9Oxuo3KX4zVBN9F9+t0NRfk+mogoV7GJCTPf41oVRAeNwRrK3JEip
         J5edCXD+W44E4lR9GbEnW4gmVhPuWMonzK/DmzMqagMX6YVbnXh64h6rd6wCvYPmmYeR
         1zc+3Qy4fSwQsuois295kdjsD7HTu/x8HIhl1AmQxgfrBGP+2soiPFGmvNcpyzIxE6wA
         ZYPmG0PO6EFoshgeQCixucOJS4/bKf0t6dIq9oYxge8b6gaVjmBnmYApLQSR1Dek9n7q
         p1mV/8nAMROWiWqv3+bsreDnJg5OKiQ+ql2qeyuGsnExNE9wBEzR7PxapbiFm05oXgQe
         7Hmw==
X-Gm-Message-State: AOJu0Yy3U8J+ti2RDn/5ckP5XZ09s12hJ0fD70Zt7pd2Yi8gNv0XE3py
        hxiO43Ub8NE+FDST6QOzjmMVVnbqNV9zacnzRJY=
X-Google-Smtp-Source: AGHT+IFaAMpm916Z8cinreZ3s5N71EYem8U+ytSE7rBXU7rhSbeUrVWkhgosQEUhHfvNMFk1jwE8rA==
X-Received: by 2002:a92:d94b:0:b0:349:385e:287e with SMTP id l11-20020a92d94b000000b00349385e287emr500745ilq.1.1691517505329;
        Tue, 08 Aug 2023 10:58:25 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gc1-20020a056638670100b0042b16c005e9sm3359849jab.124.2023.08.08.10.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 10:58:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, Yue Haibing <yuehaibing@huawei.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230808151058.4572-1-yuehaibing@huawei.com>
References: <20230808151058.4572-1-yuehaibing@huawei.com>
Subject: Re: [PATCH -next] io_uring/rsrc: Remove unused declaration
 io_rsrc_put_tw()
Message-Id: <169151750416.133230.11031331146725665272.b4-ty@kernel.dk>
Date:   Tue, 08 Aug 2023 11:58:24 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 08 Aug 2023 23:10:58 +0800, Yue Haibing wrote:
> Commit 36b9818a5a84 ("io_uring/rsrc: don't offload node free")
> removed the implementation but leave declaration.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: Remove unused declaration io_rsrc_put_tw()
      commit: 968c584cd8cc0da186befca5fc994988be61aab7

Best regards,
-- 
Jens Axboe



