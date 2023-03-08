Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F238C6B1018
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 18:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCHRWj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 12:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCHRWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 12:22:19 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1A1C85A6
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 09:21:10 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id y14so17355701ljq.4
        for <io-uring@vger.kernel.org>; Wed, 08 Mar 2023 09:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678296069;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eowScaemo0qmsEVHxvTkcNkSvckJg11OWwcE7JsdDYE=;
        b=g30bzomwLIHeSxUw9spMWKDprQSywCMfMsi7hdyG7az5Cxx+w7hsF45xMN8pD7s4Ci
         cBAr5nhcSD41Xtp2tfQB17dL6l4yB1oegwS8iAhx0dU7Xls0/VrpId6ceJCw5y+Wfpj3
         wWYlNWxq35kvLXFEs6QImYguoUUY68AumG7LTsiPwA1wDttVAZzWe8MxAhhc511bVbyi
         YvjCYXH3H6j79CCHgpCI427kuVxpDZnmT98nyjgoJbOFlsTn3HuBKXf4wYrGfwx8kI8X
         gZEFcwG04Cgv2eHvHbr2Bf8Xuqomxx9K5E/Z6BVmrKuQR1LBDqCO9ss48dmEoPA46wNs
         i8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678296069;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eowScaemo0qmsEVHxvTkcNkSvckJg11OWwcE7JsdDYE=;
        b=YAOvW2wyQJyHen5EuxpvlTJs/3nvj3LmUtf48x6KZPut5SZPpfNS3PAo7nk+ARqHj+
         ff6l0LK6P8SHIrhODAWxgcC8xGKQLb8NcL4NriwEmqiPM/S7Sx/QQKYbfV+fwVWOLJiR
         jycbOo2QLGHPCMniHPPFn5rize5QRmjjpSdBX33yraA9kQI7f+KD3Q3PQZciIAq8Blvc
         zRwDXqH92dmOMjduSF2sYQ8W6ijJhe94ng8ZO/Wh6bJKFx93zuMtxpAjEgGV11cIa0gs
         5iwlDrCeWYBg6miGcns1A6J27bOhe/lNSUv2Ti1hjPO2WRThHQ/Fu4tD1ZvDYL3WHvnw
         ub4g==
X-Gm-Message-State: AO0yUKXWxjk0BUn7NGcw1jjNE08D3owiArdgqv5HOFd8bt+nGqAAiks2
        Bv6oJY4zzkRiVXgs/BkSNY1kqOgYOOFyH7nSCg8=
X-Google-Smtp-Source: AK7set90fc2n2kgmB3sTi9kdIYQU1iOCghk7Ul7ewD/ycTFtXj4P3Q4wcdZHYAokAUrH/YactsAl95fEPmlSIo5OM4U=
X-Received: by 2002:a05:651c:b93:b0:295:944c:f37e with SMTP id
 bg19-20020a05651c0b9300b00295944cf37emr5885993ljb.9.1678296068738; Wed, 08
 Mar 2023 09:21:08 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:110f:0:b0:222:439c:fac5 with HTTP; Wed, 8 Mar 2023
 09:21:08 -0800 (PST)
From:   "Mr. Asante Richard" <r.a.k.agency.gh@gmail.com>
Date:   Wed, 8 Mar 2023 09:21:08 -0800
Message-ID: <CANiiVBtE=dy++4KJQqEoOde7UnprLtrQKp0u3u3+tGSZWFBBkQ@mail.gmail.com>
Subject: Supply Equiry
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_99,BAYES_999,
        DEAR_SOMETHING,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:235 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [r.a.k.agency.gh[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear Sir/Madam,

Are you a manufacturer, wholesaler, distributor, sales agent or sole
Entrepreneur? There is an ongoing Tender in Procurement here in Accra Ghana
for the supply of your product and different other products.

My commission in every successful contract awarded through my
recommendation is 2% of the total value. My commission is payable after the
contract has been consummated and the seller receives full payment in their
account.

This Tender is open to Foreign suppliers whose company products meet
international standards. So, I would like to know if you can handle the
supply order of your company's products to the project coordinator,
Government in Accra Ghana.

I'm looking forward to hearing from you.

Best regards
Mr. Asante Richard,
.P. O. Box AN 520
Accra North, Ghana
