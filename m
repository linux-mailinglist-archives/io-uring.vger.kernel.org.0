Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6DA5FE5CE
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJMXKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 19:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJMXKx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 19:10:53 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF1B169CF7
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 16:10:52 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f193so2860870pgc.0
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFtZli9uGfxWeS1W/0SFdm8h0C6LKC7jkUWB4gufJj4=;
        b=SFOXxtdCKhRYURLQDDRK2283p9I/9t2KYLXAQqytmHxq/Z1yw8ju3uQe8XUVjC8jRW
         ZMZnRLd/tOHBFD09LobRdf5I5vXYwO0gnieKQr/Sr8OdIiG9NUFGjmDZS7E3n+z/HQbZ
         s+UmR9E2TkrLTwaFhsFUb/otBAcUXzM7mPOM5YVSbM+ewoCCpJHcpclhEmdJT4xXf22v
         TA4nYtzmCY3h4F3x7ie5hyDUgSW161TdJagWJfZENYY/jqzmb/KhQhBeRtjQetfR4BQE
         ghgr/V/LeZkTyIbqgtr5/7uMB4b0QMpIPmp3lxZmg3CU2UqkJ+dQawPzd+W4UsOh8Vq8
         m/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFtZli9uGfxWeS1W/0SFdm8h0C6LKC7jkUWB4gufJj4=;
        b=zXiUiFA1CJGCvbd+l//4iMDGBoHws6l9VtBK1NkDGU0m7d1xQmyg9KPf2GF+y0Y4FM
         WDGIbWsR5k5CF5iWZIdhnqvkJ3GY/AP/zVImBHe8mBUq5XjdTKmmuPXNnnOmPAvaPt09
         lWPsFl/YNrhJF9EmJQHAsX61WrZ9W26LE/RfoB4OopX1ZWG5Hie3SZKKp+bXNcQoKniY
         WRqOnxmq+7FepZnSXftKY2TJvGXku8f7n6nXMPTdVHrK+HqTsIsQEjAfB7Bq2fklLNSh
         1AUVU59rlQ/3yMWgER/LUgsbIHqzw62+OUUv83stJQW0t8hOANVDWk/P0G92psjfJM0A
         NO4Q==
X-Gm-Message-State: ACrzQf2oq1+uDCrvvEagp1X67WEV6MkotCv9231G+0UMHwlKWWzWQlUB
        hKr/7KT/M1kT66nRosz/bRwPdeEJNzaoSA==
X-Google-Smtp-Source: AMsMyM7pjMa5rTowNCThXhnkApbF4n1yHZi7HUS7ABGwwnk5h8IjyXPLNIvGydIbyp57n5yR/KzzGQ==
X-Received: by 2002:aa7:9152:0:b0:565:895b:e524 with SMTP id 18-20020aa79152000000b00565895be524mr1913205pfi.85.1665702651553;
        Thu, 13 Oct 2022 16:10:51 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:4b11:34f0:81d8:3912:f344:7df7])
        by smtp.gmail.com with ESMTPSA id n18-20020a170903111200b001782a0d3eeasm365067plh.115.2022.10.13.16.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 16:10:50 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
Date:   Thu, 13 Oct 2022 17:10:38 -0600
Message-Id: <85403545-DA41-49AE-834D-AAD9993FF429@kernel.dk>
References: <CAHC9VhQCLQogAFSvAy4AtL8VzHX9dtUetFsV2HpqR0FVWkiiYQ@mail.gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <CAHC9VhQCLQogAFSvAy4AtL8VzHX9dtUetFsV2HpqR0FVWkiiYQ@mail.gmail.com>
To:     Paul Moore <paul@paul-moore.com>
X-Mailer: iPhone Mail (20A392)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Oct 13, 2022, at 4:58 PM, Paul Moore <paul@paul-moore.com> wrote:
>=20
> =EF=BB=BFOn Fri, Oct 7, 2022 at 2:35 PM Paul Moore <paul@paul-moore.com> w=
rote:
>>> On Fri, Oct 7, 2022 at 2:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>=20
>>> The msg variants of sending aren't audited separately, so we should not
>>> be setting audit_skip for the zerocopy sendmsg variant either.
>>>=20
>>> Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
>>> Reported-by: Paul Moore <paul@paul-moore.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>=20
>> Thanks Jens.
>>=20
>> Reviewed-by: Paul Moore <paul@paul-moore.com>
>=20
> Hi Jens, I just wanted to check on this, are you planning to send this
> to Linus during the v6.1-rcX cycle?

Yes, it was included in the pull sent out earlier today.=20

