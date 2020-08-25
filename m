Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7B251BBA
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 17:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHYPA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 11:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHYPA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 11:00:57 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF69C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:00:56 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l13so5597696qvt.10
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=I+S/MKD67cQSMNIQNrwCtfE94w9V9BpiyRolqxN32YQ=;
        b=G4egCKSs7na23YztnVk9uUCQblmyDqqy0Ubz/AiwX1S5Do6rz5SyOsZUJZsSaMoTPx
         7ofUVzjVzBWl7KeiKd5iQK6cNqsYcYSvwKJ+r+gkqYcRKhcLM9riSEIStYc/qvskn+XB
         eGxNxkz5/GCxxWxCobUXoEnWIxebrhrAiqXkiMhZ/JD2uDBIV7wZ4iIJuuEJo0lTzee0
         9DNki8Wj+ifhZWF0yO7uQNfNf73kqSsIBBayw5RZJTkL9UN9dyHcBgK5b3BX+A9A2mFQ
         SPVCoyAD7LOVwS7oGSEXDT34HZvWN0qtNDcFY8n9NmsVLgGoOn2XO8W5ROryyjuzbmn0
         +l8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=I+S/MKD67cQSMNIQNrwCtfE94w9V9BpiyRolqxN32YQ=;
        b=SHaHIvlv6hdQSUMyEkUajkj5+/tUX9rSBxn+OXn/tCJejpcEjAM2iA9ABgeoSlxsJV
         uXKPUW1Zoh+Mhbbj39mvNZP1+Adv4i8Pd5Vou8dr+fVirbi29VedjKgHKT62/MLeHkM8
         4KPu4wAb/R0YXAr98w60gpj4HF/BGXt+GzkaIu4tJlT1r8sPbaWm/QgfDKPSznDqtKLO
         ND9HarQou+R1I3rnZn57eRNr2pK+tA5J4Lv/Q7z89fiWslRks32YaLj9gVsd6UPWOx65
         dJsNTaN5m2vraf2ggN0+iuNxOW8dWqP+ah44F61/zlQGDLa67GKULcpHntSYryLRq0Mh
         Usfw==
X-Gm-Message-State: AOAM530cKt0zhCUi07zjxZ9puhr/8wEzD/qUBtz/rfyLX2UCsagpOq/t
        /25aGaxWHmEAeg9Bs44im489j2HA2pEug4Os7+o=
X-Google-Smtp-Source: ABdhPJzidHJToiCZ9CzIk2Z3ZyMTTN2Px7CLqiOffJD5I36WITx3zinUDIcZOKfA9Bh8yvegMZtDfxSpowFjJQ+koC4=
X-Received: by 2002:ad4:49aa:: with SMTP id u10mr9874207qvx.27.1598367655740;
 Tue, 25 Aug 2020 08:00:55 -0700 (PDT)
MIME-Version: 1.0
From:   Josef <josef.grieb@gmail.com>
Date:   Tue, 25 Aug 2020 17:00:44 +0200
Message-ID: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
Subject: io_uring file descriptor address already in use error
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I found a bug submitting a server socket poll in io_uring. The file
descriptor is not really closed when calling close(2), if I bind a new
socket with the same address & port I'll get an "Already in use" error
message

example to reproduce it
https://gist.github.com/1Jo1/3ace601884b86f7495fd5241190494dc

tested on 5.9-rc2

---
Josef
