Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE66E05A5
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 05:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDMD7U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 23:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMD7T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 23:59:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137AB86AA
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 20:58:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i8-20020a05600c354800b003ee93d2c914so8960625wmq.2
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 20:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681358327; x=1683950327;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNCYWc3+395/cdIb4O8onIiz31xrMP58ieof9MiWNmE=;
        b=R8jVtSJBTstzUROpKWrWekDoMYmILtRvXuq1LsaW8Vo8LzrPLMoVPDvOxQTVIgaxKa
         Z6Of9K5ioPVpbAQtUNVhoRRFfUVu5bcFChPCeB6eceChxqTDmbHc1xcaI6wk5O8xcEfs
         HQI+0Scec7v6I8eTk/smFuToLu68pwKAbg91HihOeLxLxcq7p+CBq5r3+DcCzTT0f/92
         kvlSJgywzCNJOP7NhGsxbsFCfRim2/+50chJVaqdamChGwJeH1h2pgYlxnV90X/2Ev0O
         kAJ3jC1cusRYHSusTsdaK8hdke7Nhr+DngXRUVJi2OeFHtYJ5mICyW2YOWTUxL7KMo28
         SY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681358327; x=1683950327;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNCYWc3+395/cdIb4O8onIiz31xrMP58ieof9MiWNmE=;
        b=CEU5DW8lpKJY1zr7Ggi+IywLxw6A2tMJedKjrMQa2rMLfqmh9NDmiXoNEyhfN/dwJO
         65SO2EAi6wjVdKHFJ389Ba703dWGld6lQ2GJSMaXSLbxYUIkVaBRiv5R3j7QwXjy4sJ2
         hQFF9GAG78yPl+Ckcqk9yPtIXAokizf+R8T6PV5oVpL4ccoKc0Q4+m1DasHaB/OIIoD4
         KGtUC51gsZiq1g/czwpkwute4WklJnofMnK4HKwytsUfC/wbbjM51ya1UNYOFcLpyfA+
         D9VLHZw8vU8JN4IVXkEPu6qurXSEsEAnquwm7uSottjfOMrJGLpUxQ+MD9iasJUdSb7L
         3f1Q==
X-Gm-Message-State: AAQBX9cbIKep74rLE4a8aeSycJSe/eviZ0dfJVZhNHm8v7eufomcFNaQ
        xi1iCouBwOc7L4//RpeN4iseTAVO3gLD57lIzBs=
X-Google-Smtp-Source: AKy350bo8R9saM+g7Fm7mdvC4LPMa5471bzsPw5CA4O05QRxejqzFN6y5h7m0+EmqWx+Vn9FydmY9KKSF7LxqL/D5Y4=
X-Received: by 2002:a7b:ce8c:0:b0:3f0:8add:2710 with SMTP id
 q12-20020a7bce8c000000b003f08add2710mr229026wmj.6.1681358327340; Wed, 12 Apr
 2023 20:58:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:eec5:0:b0:2cd:a55:7b0a with HTTP; Wed, 12 Apr 2023
 20:58:46 -0700 (PDT)
Reply-To: roland80@email.com
From:   "Mr.Roland Philip" <paolomark015@gmail.com>
Date:   Thu, 13 Apr 2023 03:58:46 +0000
Message-ID: <CAJaxUbKwAebaDRixL42UOfF3m5QyLDddG=Yoy0o03dFrZ60G8g@mail.gmail.com>
Subject: Read the message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:334 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [roland80[at]email.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [paolomark015[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [paolomark015[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.6 ADVANCE_FEE_3_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

My name is Mr. Roland Philip, can we work and share this project
together. If you are
interested I wrote you an email this week regarding to one of your
family member who died
here in our country and left some huge amount of money in one of our
bank here so kindly
acknowledge for my advice more details,please urgent reply to this email address
