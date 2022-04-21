Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753C350A8E5
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 21:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387034AbiDUTVy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351011AbiDUTVy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 15:21:54 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC13A4B41B
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:19:03 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id i34so5417613vsv.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=SvKsWt9LONNBbmyn76CUaIRFpx6XrGejj9uupqUqu0c=;
        b=Dr0+51mZqhi/+6RJI6MTYz74cOB5AfgxxZMOiDVTr9AcDVKNvNME0X8nSZmX73si7x
         BF5yOIW8KwdSzC1ozWVem8XeqazTrbDRqHvWsBKDdX9TlgDwQvVd9aP7yCS6G1D34bmn
         0GL/N1s7QfE3L/FoY3VVT5uu59VfNs70XgovagUrMPp47IC+5FcOIUOwMVLSFPyd20t0
         /j0ApAj/UtDQCOiOKqZZntkAVDrCd4KuyDWn6dA7GajPOuRvJsR3vC8PCJRG9O9p/arZ
         yVyqcT0YsOpO0tf+fRwmP/I5GEnNpteAzhzclSXhEUQtxyrBkM9Avl0UWd6uk6FZrELQ
         OwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=SvKsWt9LONNBbmyn76CUaIRFpx6XrGejj9uupqUqu0c=;
        b=ozALQCcfE8qi9jBem6gzKi9io4+x394syDU2aYJNnMg/evcu4U4h+lwlEvxMiDd3Zv
         sIxGnn+hgGDbRslCGtEO5Gn9jq0CEiwfvmqZwR0HNtGh65z+Uar3XQpkVp5rzo8YksVh
         AaviWJNFgmPR9aoPzRTPvwdaZwJy8iEmb5euKjIgj5jVUarBRYDoEdn8SuMd4SXhk/2B
         ZQyk9Ta3G8A8E0kHUBncopjPSsy8FINtRyju9ffoDoofbTjBXaMIje/M/fZjm5W4Lt2+
         oQf1Y9KXcH1MqmW1RiCD9W7MNQtH6yQAz+omU1ZMoZIOOVZlwA5bbP2kqBEyw3F97cDd
         Nriw==
X-Gm-Message-State: AOAM531Yk6VV/HinBh+92WX+FGbPFIzDCAisKmmWkYv5FZ1UHSvODVUc
        r3Ok8GIGk4ks/gxLLoNPTOBrprrM3XRoyoWOQt4=
X-Google-Smtp-Source: ABdhPJwXrxobJIgqlvB9vmi0SaIa2rDM01QkPa3gHaIkqylVNuXhdUHhJ0PrO+FLIf1t2peJfqJgiWTs+YZVlwiREaI=
X-Received: by 2002:a67:f796:0:b0:32a:cb0:bb40 with SMTP id
 j22-20020a67f796000000b0032a0cb0bb40mr365039vso.36.1650568742937; Thu, 21 Apr
 2022 12:19:02 -0700 (PDT)
MIME-Version: 1.0
Sender: zandan8693@gmail.com
Received: by 2002:a05:612c:80a:b0:2b1:317a:8233 with HTTP; Thu, 21 Apr 2022
 12:19:02 -0700 (PDT)
From:   zanda zanda <zandavermaelen2@gmail.com>
Date:   Thu, 21 Apr 2022 21:19:02 +0200
X-Google-Sender-Auth: TXoq2B2W9tWw5j7Yj6u9Rxf6nLA
Message-ID: <CAHRnin4bosg8+TH-bZCFHVbYTJVmfaTfmNiq4wamQKcQbBrOKg@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
I haven't gotten a reply from u after my last email
