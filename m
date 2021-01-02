Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555122E87C4
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbhABPWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhABPWD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E5C061573;
        Sat,  2 Jan 2021 07:21:23 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 3so13738288wmg.4;
        Sat, 02 Jan 2021 07:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJBITHaQqc5xps2gqOqR24Tyr4hGdZImALfk9kxilUw=;
        b=NvGUGxltRkygnkWt8il2VY/VOJmppE+yq+zgwo8hmdFcFZfjYtKFZ/rhfCOQnBc+Zk
         8xThlikKe45cXimJXDIexKr7ayg3lOvYuqlm7LgZ+jrDz+Caf5N0QJE0y2dlCjD+xd5b
         sZMQP1sfAQPp+AM5Lig7wFNbxAechxk7ODSAJUgidqhfDVnAMOEFrXTIBGx+mFecPof/
         RDRBMGsxVZmpKew2I0jLuZP/b9FqovcagcOCF3EuI1HhVpskaO+cUtenCizeHbbVp9KI
         51z/mVU+s2eorqGFff/E7J47uV8DTSNJnYfBx8YnDhAPSiT9kSXtkQj0iJkYru2Hw4Zk
         VRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJBITHaQqc5xps2gqOqR24Tyr4hGdZImALfk9kxilUw=;
        b=rpMIAIeirbUfTJ56EvS5BvodnXqMozM4plCagANpQ4XaDpxq1XmqmOMZwWUokqr4JN
         4QRg/sHIzrrJ9O5gFDQ0eh1zdho+r7ttOrZb8dA2dMK9MpK5/VAKj9bZpCOsIfzZPY83
         JlwuvtkhjnaVne7VbXG/7GDDDxwrmNQgECFHKafgevYVLUhxfSmhGbCiKqmFx9sp11Dl
         9RN4S5m3cv5pTjh9iF7RNtgKFUjKpBG/BH7DnbAAx/w/8kU8t6v7DcfxuAFWzPcFMueP
         eXCGLsBUVeb2jAWQSCgUSieprF8FiD1GyOW/6jAdEKTMxj0hZ+VNrvZMoL8b3RP2Mkc1
         oyvA==
X-Gm-Message-State: AOAM533oIgF18UiNDvLB0e7NC2RavlPdNakp5Ahbe1BlgAT03rXnc+fA
        VIsyaJ97NNnf1NMBFO/yK2our1I/8s55QQ==
X-Google-Smtp-Source: ABdhPJz1HKKwKxVCoTsKOjB/MYoTeJtGzrGeOEkTWLP+7WGm6nET026PZQx1ZUd9bCXYV2kgxNirfg==
X-Received: by 2002:a1c:87:: with SMTP id 129mr19523015wma.183.1609600881470;
        Sat, 02 Jan 2021 07:21:21 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 0/7] no-copy bvec
Date:   Sat,  2 Jan 2021 15:17:32 +0000
Message-Id: <cover.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, when iomap and block direct IO gets a bvec based iterator
the bvec will be copied, with all other accounting that takes much
CPU time and causes additional allocation for larger bvecs. The
patchset makes it to reuse the passed in iter bvec.

[1,2] are forbidding zero-length bvec segments to not pile special
cases, [3] skip/fix PSI tracking to not iterate over bvecs extra
time.


nullblk completion_nsec=0 submit_queues=NR_CORES, no merges, no stats
fio/t/io_uring /dev/nullb0 -d 128 -s 32 -c 32 -p 0 -B 1 -F 1 -b BLOCK_SIZE

BLOCK_SIZE             512     4K      8K      16K     32K     64K
===================================================================
old (KIOPS)            1208    1208    1131    1039    863     699
new (KIOPS)            1222    1222    1170    1137    1083    982

Previously, Jens got before 10% difference for polling real HW and small
block sizes, but that was for an older version that had one
iov_iter_advance() less


since RFC:
- add target_core_file patch by Christoph
- make no-copy default behaviour, remove iter flag
- iter_advance() instead of hacks to revert to work
- add bvec iter_advance() optimisation patch
- remove PSI annotations from direct IO (iomap, block and fs/direct)
- note in d/f/porting

since v1:
- don't allow zero-length bvec segments (Ming)
- don't add a BIO_WORKINGSET-less version of bio_add_page(), just clear
  the flag at the end and leave it for further cleanups (Christoph)
- commit message and comments rewording (Dave)
- other nits by Christoph

Christoph Hellwig (1):
  target/file: allocate the bvec array as part of struct
    target_core_file_cmd

Pavel Begunkov (6):
  splice: don't generate zero-len segement bvecs
  bvec/iter: disallow zero-length segment bvecs
  block/psi: remove PSI annotations from direct IO
  iov_iter: optimise bvec iov_iter_advance()
  bio: add a helper calculating nr segments to alloc
  bio: don't copy bvec for direct IO

 Documentation/filesystems/porting.rst | 16 ++++++
 block/bio.c                           | 71 +++++++++++++--------------
 drivers/target/target_core_file.c     | 20 +++-----
 fs/block_dev.c                        |  7 +--
 fs/direct-io.c                        |  2 +
 fs/iomap/direct-io.c                  |  9 ++--
 fs/splice.c                           |  9 ++--
 include/linux/bio.h                   | 13 +++++
 lib/iov_iter.c                        | 21 +++++++-
 9 files changed, 103 insertions(+), 65 deletions(-)

-- 
2.24.0

