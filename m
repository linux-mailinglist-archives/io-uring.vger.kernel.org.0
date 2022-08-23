Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45359EB03
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiHWS3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiHWS2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:28:36 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DCCC6CE1
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:49:20 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-11c896b879bso17481756fac.3
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=V3gIx0/iz2IpSOrJXxSrSzDLBZ8gouoBDdSWGS957I4=;
        b=iMj05GYlnz592M2SJ+84MEaIyaOU4aD+TDkDijWCcDjBKg7eY1AKZr3v3Dt3d2uJDl
         jsE5XajRjNnFa5BPA2EU6RpizRpJEk+S5iYZfw3qNhVpXOdeulkqe7bkIjTOE/BVO4YC
         69pExpJ+602ZyPoW4PwHuCmu7mGMPW7HirLGoqMGp3B7X0wul8eem5g75RSmYEZc0ZJz
         sDyqVggcw4wqoFWfcC1gW3U4J9J2RE5CLANEA+wIGRwxHDEuklsKBR4WOY0tF6ATlljz
         i53xYWImDpnYeHzA/HCnRgNfBXJjEHJj0hCUipVuFewJNV1a4i6ogUXLeiclOGzhZG3t
         g+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=V3gIx0/iz2IpSOrJXxSrSzDLBZ8gouoBDdSWGS957I4=;
        b=JqW+gx0hhq3kuERHBfxlUJYyxx/j9EkatKQKpaO9QpmK0EeT6WHSQKEzJriOiQvP8C
         rGaIEJtgC6ikFEJEYA0R52CF7viPRvtGy7xNHQEf6Hfy5YBJfDAGO+5sur3879QLHCKb
         WziW7Kk3xbo8+a+Uyx0bzF3LiuG8qraQqGjleRqW1i6sGNNLoe2Y779rU3YqOUzFBagu
         uN4zV6AmM/IitisqW3fsVJMkNaBOax2+bNeiRGKkq4RYJeVSK7EIdmPoKsnetPUPC2ff
         OK9Yb+wbvxkZiBXv5opyL79LSSUz3YRiBhjiWvf4+8Qn7OKouI14qKdKIA7CLk5vMLY6
         xfPQ==
X-Gm-Message-State: ACgBeo1qpSaGh4zqA8mkf86+vyNSaCa+/4kLE67s5k0YF34RDWmOdYkr
        yz1lxxLX85JBc/b/I0xf90NAEC0CaDadHwl/3g5M
X-Google-Smtp-Source: AA6agR6YAA/EliMosNOFZlKU3FbX7Edq0nNdiCzH/CpOwCu2ISzQ6G9JQ8ZjLFNttkmDQTVphvQ8c+dSjGaEWVgGbw4=
X-Received: by 2002:a05:6870:7092:b0:11d:83fe:9193 with SMTP id
 v18-20020a056870709200b0011d83fe9193mr1824943oae.41.1661273359114; Tue, 23
 Aug 2022 09:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327379.369593.4939320600435400704.stgit@olly> <YwR5OZ+tsu51pB8l@kroah.com>
In-Reply-To: <YwR5OZ+tsu51pB8l@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Aug 2022 12:49:08 -0400
Message-ID: <CAHC9VhT_r0+=407KrVGinSEFKo-FAGboSXtmqjrqdj95b=Gh8w@mail.gmail.com>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM hook
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 2:52 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Aug 22, 2022 at 05:21:13PM -0400, Paul Moore wrote:
> > Add a SELinux access control for the iouring IORING_OP_URING_CMD
> > command.  This includes the addition of a new permission in the
> > existing "io_uring" object class: "cmd".  The subject of the new
> > permission check is the domain of the process requesting access, the
> > object is the open file which points to the device/file that is the
> > target of the IORING_OP_URING_CMD operation.  A sample policy rule
> > is shown below:
> >
> >   allow <domain> <file>:io_uring { cmd };
> >
> > Cc: stable@vger.kernel.org
>
> This is not stable material as you are adding a new feature.  Please
> read the stable documentation for what is and is not allowed.

Strongly disagree, see my comments on patch 1/3 in this patchset.

-- 
paul-moore.com
