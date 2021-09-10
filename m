Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1E54070DF
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 20:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhIJS0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 14:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJS0x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 14:26:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4D0C061756
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b7so3495645iob.4
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Vg/TxJx63a6Prh8d9/6qNscaebIESeGpR+mOWO6b+k=;
        b=0ZN5l7orVRtwjzzB+pmEYI5kgoJZ7L99LqxCzkXrNqh6xI5XOuWyHvDrws/fa4awJz
         MUqxIwfAH2INCzV6t3EAlgvJ9cyFD9bTNbtsdFwDlRgKIulI4TcansNR5Sq0YZbWdoJR
         Bj8QoS6q9BcItcjZFkF4c5U20GNRujXXgssl457TUHotb+NXi4raxVXfqUB3ieNHEgfZ
         6HDacflIDY2lCvGkVFOhnpLo24uJR1c7S36CsjNHly5Nzy+TaG8XPv4hMaSrJMU/+kqH
         ih2o6M9yu71V3UP9UUqrOLUDkjbQLRZHPQSNINuItIT8+KqIo/+8NTODEG2ZrZi6nbyE
         oUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Vg/TxJx63a6Prh8d9/6qNscaebIESeGpR+mOWO6b+k=;
        b=zfCHvm7Hp4RZf/e16oky9OZBAOnoY+q6HzVHSfQgUWzib6QrWAGpdSExB1lnjBAIa4
         CgoHJE+v01KTTARnQFanUdMTOOvg89/swGEnRmmWgD5rwDrW9jezi6tW01EMgYuAnX0q
         BF7Y26l3CtG0qQZ2oVlnRp9EFJPullBDJQSQNR+9POwtppO8HxufQ7RlyOBiywZK1pwP
         BYRcjX+fT45sZZsRZjYH38XSBnqLEXwgtFRwkv4011fkLZPkF0SeOxhBacZLkaAl7vU5
         5R3ltxzBpy0hF9tQ30WinSrP0uFvLYL9ul4CADIsS0QfF8Shlmj6Q8BsmO4TX6bSr3Nb
         d6zw==
X-Gm-Message-State: AOAM533sUQuAOn+jqqWjmhARPONvrSGheW0MT16po/xL4tM1ZDSJk2es
        j/kg0e3E3+pyeAN65V2p7xwXOfMi2Hl//z7SqiY=
X-Google-Smtp-Source: ABdhPJxVHW7Q5mx1xrhGM4a6BQn7Vb8+mSP0KRnQLSfr+uhoGu2/u+bFXw+qqcMqtXuheY8+PsQlLA==
X-Received: by 2002:a6b:c3ce:: with SMTP id t197mr8107952iof.159.1631298341644;
        Fri, 10 Sep 2021 11:25:41 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c20sm2575149ili.42.2021.09.10.11.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:25:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: [PATCHSET 0/3] Add ability to save/restore iov_iter state
Date:   Fri, 10 Sep 2021 12:25:33 -0600
Message-Id: <20210910182536.685100-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Linus didn't particularly love the iov_iter->truncated addition and how
it was used, and it was hard to disagree with that. Instead of relying
on tracking ->truncated, add a few pieces of state so we can safely
handle partial or errored read/write attempts (that we want to retry).

Then we can get rid of the iov_iter addition, and at the same time
handle cases that weren't handled correctly before.

I've run this through vectored read/write with io_uring on the commonly
problematic cases (dm and low depth SCSI device) which trigger these
conditions often, and it seems to pass muster.

For a discussion on this topic, see the thread here:

https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/

You can find these patches here:

https://git.kernel.dk/cgit/linux-block/log/?h=iov_iter

-- 
Jens Axboe


