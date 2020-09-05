Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65025E931
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgIERDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIERDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 13:03:15 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03B8C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 10:03:14 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id q9so9512405wmj.2
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 10:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=Qia2MyHCPJcAe7pgKBNE4nd24lPeR0oqtsBWzkt0U/w=;
        b=IlDAUTAP58gFB0INS94Rjmw9bazB2H7jhXRO39SDUQlYYcmHQ0SVLRUx8vBXgvCVxu
         8LRd1k7Gmq2Ofx76E9VlgrmTqRWmWlzwvYYftp+uEYe/NJMsCwPABQMCKoFT2oyA2RKK
         TqnAwr5kfbZxz5ZVQAh4ac969rHC50P3gf3IYECsq++CwNN6UUdTDZ0q7CxXER26eqNO
         leMPrI28bPznaJfpaY/nvFTNCXwk4ftrVF6bNfzb7Q8oSl3Rzl1iBR6Yl4zot8pmhfDj
         5PszFRJatnMjfbuOMGT4F+khF5mhvWR+RtXOw4ZIMSt3OA3Lu5sd6+ZL9FabAz/+08BJ
         w9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=Qia2MyHCPJcAe7pgKBNE4nd24lPeR0oqtsBWzkt0U/w=;
        b=Ec5yCKRfB2DLRcH/mwPwayZWZQBOHJVZZWMAwWLj5ZOaUoqOcOUvGF8li3OcG1oiIY
         cLQjXRLdgH/NwKbkUFHKmwahN3ybDVe0FZfGlPzBTLBtHXUG/lYK+we1W40IrilMYOJG
         YX0031yJyy0fB3WcrsLfLpMXs2kQFvNvlOxvmsxl1n0/VE1Y4Rx+ylUhlkr6xfC3jFPG
         k1YHSycTYOIVmTt3Oq0ugE50HXGrAElnntZOVlupmGDazH248KBFz4NCLYItvjvgl9tA
         WGe0wbrT3JIMjvki+ADYVZX6GaHKhjRfZfZfdlGu7YCddUEqPF955zpVqjXj/ERxDP3S
         HCMQ==
X-Gm-Message-State: AOAM530yJrgHI+daSL93NMxqoVcp3d62tZ/BmW1P0e0ivi1Bw7tyf/hf
        Z5bYy7fDoOT3eE7zf8ZyBGo7CfRCuCa9EQ==
X-Google-Smtp-Source: ABdhPJyMx5trnZcyybHo+KCV1TKbshRlccSGeDtmE1bReD2qfsNMn//ZkPt0OXi/XY18ydLN5Zw6YQ==
X-Received: by 2002:a05:600c:2906:: with SMTP id i6mr5372657wmd.48.1599325393237;
        Sat, 05 Sep 2020 10:03:13 -0700 (PDT)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id n4sm1422240wmd.26.2020.09.05.10.03.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:03:12 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Support for shutdown
Message-Id: <406D0D85-DF4B-4EAA-A6FA-D1EEC3F6343E@googlemail.com>
Date:   Sat, 5 Sep 2020 19:03:12 +0200
To:     io-uring@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi there,

As you may have noticed from previous emails we are currently writing a =
new transport for netty that will use io_uring under the hood for max =
performance. One thing that is missing at the moment is the support for =
=E2=80=9Cshutdown=E2=80=9D. Shutdown is quite useful in TCP land when =
you only want to close either input or output of the connection.

Is this something you think that can be added in the future ? This would =
be a perfect addition to the already existing close support.

Thanks
Norman=20

