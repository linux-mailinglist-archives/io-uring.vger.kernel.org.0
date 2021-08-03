Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB32E3DF570
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhHCTU3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 15:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbhHCTU3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 15:20:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2BAC06175F
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 12:20:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so5389670pjs.0
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 12:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kh4/LKREaQ31XQ74nFXvaNvYszlH2weVd3fa4SRIf4U=;
        b=RocfLuXl4nOPAJs9iN9bHdEFGfGvQtTlscasiu1/ETqlRAyHyu6Mh2mxf3usia16Ij
         VGxtg4E1JCQuHwtyCNzXMsZWWiqh7dpfaI+tphbXqf0knEH1MdxSMU1Y/MDrfdcJX397
         +Lc/j413D3aqm+xqamu6tnXTV5kRTPgKzgco0b9HNNeBolSh7hA4R+HtsQhuEIqL4+RE
         XeoSJYj4lQBFzPlt4OZ3rxtCCGrA5ed/vO0+oNoAInIIonV4qXAWOHZyQquDcU84pFkU
         83tNmzmsNjrx4WnJ7+DriBdA6eZ9Fw9chMrSOaeMmCe2GF2qCu3Asp0uGmdJpSp6+0Sm
         dG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Kh4/LKREaQ31XQ74nFXvaNvYszlH2weVd3fa4SRIf4U=;
        b=spz8cucoWdVpxlS5GZWjg1lJWbc5jeog5fXCt/CdTZRZg520t7iFvKfEvsTLgu0Gq3
         9A9gnIzSMp0YtIxvDXf9ArQFuD+yEulRo9qsz4fM/DCYSqkz56N2YGbYJDWPVxDjXUKb
         fcMqKxyE46B7SlO2+2CD8I8tgugTPWW0xJMpgdnEpxjMmwmohMesWmf2VAgFvmV/xQqW
         /Tn3OCSWeu18oCbpV+Uz6KTd0QAfotGZlh2ZUIDfs5X7mfOO7FslShynVGteVvbLTKP7
         w7hX9420WraxwJ4TDsWCxIuck6U98mrrfCO9WX9CsE9eEyDDTaNF5HiTyExDOMulWS41
         iKSA==
X-Gm-Message-State: AOAM531qVOpHoYArkzxd2Pz0nYGZtZ27/ob9Bvz0QwoVyQ0Kb4/rYuxB
        fm5RMjcNQTyLjvGDlURT7X0/Ia4q8xKpRw==
X-Google-Smtp-Source: ABdhPJzOf1rnby6BS2bJ8HNF1KgmAETFjl0ARJhI3VGRiN9F9gye6Q9g12Fo7mUQ8yPAmNN16Wxhgw==
X-Received: by 2002:a05:6a00:1508:b029:332:3aab:d842 with SMTP id q8-20020a056a001508b02903323aabd842mr23615599pfu.59.1628018416769;
        Tue, 03 Aug 2021 12:20:16 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id i14sm17544454pgh.79.2021.08.03.12.20.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:20:16 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
Date:   Tue, 3 Aug 2021 12:20:13 -0700
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
 <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Aug 3, 2021, at 11:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 8/3/21 12:04 PM, Nadav Amit wrote:
>>=20
>>=20
>> Thanks for the quick response.
>>=20
>> I tried you version. It works better, but my workload still gets =
stuck
>> occasionally (less frequently though). It is pretty obvious that the
>> version you sent still has a race, so I didn=E2=80=99t put the effort =
into
>> debugging it.
>=20
> All good, thanks for testing! Is it a test case you can share? Would
> help with confidence in the final solution.

Unfortunately no, since it is an entire WIP project that I am working
on (with undetermined license at this point). But I will be happy to
test any solution that you provide.

