Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C256644D210
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 07:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhKKGzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 01:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhKKGzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 01:55:35 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC7BC061767
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 22:52:47 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c8so19925069ede.13
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 22:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bF/mvudvlUErsGH2FkukhM/UNmg7zIP8cRNxAMSC03Q=;
        b=Xrt/jV0E3g2dy5ULTmHCZNFnNG7wYCAVDU2H9SDOMofxHVU/ERtlnAFA96q6OcIIko
         feUGzeYPXtOt+rfV+JACe8UQAlEkS+xO/nbMy56imQJgpVPDFUclcARplQfFu9fsK7EY
         BGXXlWgaYgCIjmJu+SC3eTkm7ZNDGH9uxoeMcInEuDEMuze932SWSLeirjqDBz4MxLdE
         b9CfbUkpToBplZRt94AXIIH5fY4FFp4hlcaH8ghdZz+KHDb/lJfuOcGBvHXqLteWlEAy
         +dz6in+UvUvx+o5FISRztm/FTAZinQHa9QjyCkwgzUw9UdbFAb7NxymgTU2MZ5MpVBts
         F/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bF/mvudvlUErsGH2FkukhM/UNmg7zIP8cRNxAMSC03Q=;
        b=Mung9NylePot1AxtBm3jfbiJPXDVRddd/Tu7tjdc9gj/A8hjkNDVFL1z7umq2LzVfo
         og8t15fa7nKzX4qlmHuUkQeZ8971UGX5H86ibKjNuBkOPaz6cnkHYAruAzKjX7EQlgTk
         3QBK4y/kYjgZdaXaIwZ1Uw/H6buMwMLqw/eff+Y+p0ljHyFKMvYhkACaERYy+21v/Otn
         MBFUbBOPGQeq2n3bsMyXc01E0rtDXXpH1LKAY0Trq+jOFQ+EpevnBEMCXSjlrJm8uWjb
         tAyqSUi7xVsn6qqshQi5FNy7eZqam9TNBRlwrav5ditVdOY09z3t2ipZE5sD5BGXYP1O
         Yc3Q==
X-Gm-Message-State: AOAM532zN46smos196j6EPXf+pplYy5Dh81RM4FCtcP5VvKYbiCVVvzB
        dQZoiXeuaAD09XORyF0RFcnM20OxtPeMQqlKt+8QWw==
X-Google-Smtp-Source: ABdhPJyv8Wxw+RJlSA7ziCpw12XrtXbNnRNf7g7qk9IZ/oy0oUoY/WNOGE9lHx6n6Dbx8ra/kHDc1e9a316hAgDfGts=
X-Received: by 2002:a17:906:8256:: with SMTP id f22mr427149ejx.207.1636613565395;
 Wed, 10 Nov 2021 22:52:45 -0800 (PST)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com> <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk> <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
In-Reply-To: <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
From:   Daniel Black <daniel@mariadb.org>
Date:   Thu, 11 Nov 2021 17:52:33 +1100
Message-ID: <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Would it be possible to turn this into a full reproducer script?
> Something that someone that knows nothing about mysqld/mariadb can just
> run and have it reproduce. If I install the 10.6 packages from above,
> then it doesn't seem to use io_uring or be linked against liburing.

Sorry Jens.

Hope containers are ok.

mkdir ~/mdbtest/

$ podman run -d -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1 -e
MARIADB_USER=sbtest -e MARIADB_PASSWORD=sbtest -e
MARIADB_DATABASE=sbtest  --name mdb10.6-uring_test -v
$HOME/mdbtest:/var/lib/mysql:Z  --security-opt seccomp=unconfined
quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
--innodb_log_file_size=1G  --innodb_buffer_pool_size=50G
--innodb_io_capacity=5000  --innodb_io_capacity_max=9000
--innodb_flush_log_at_trx_commit=0   --innodb_adaptive_flushing_lwm=0
 --innodb-adaptive-flushing=1   --innodb_flush_neighbors=1
--innodb-use-native-aio=1   --innodb_file-per-table=1
--innodb-fast-shutdown=0   --innodb-flush-method=O_DIRECT
--innodb_lru_scan_depth=1024   --innodb_lru_flush_size=256


# drop 50G pool size down if you don't have it. Not critical to
reproduction. IO capacity here should be about what the hardware is.
Otherwise gaps of 0 tps will appear without it being the cause of the
bug.

$ podman logs mdb10.6-uring_test
...
2021-11-11  6:06:49 0 [Warning] innodb_use_native_aio may cause hangs
with this kernel 5.15.0-0.rc7.20211028git1fc596a56b33.56.fc36.x86_64;
see https://jira.mariadb.org/browse/MDEV-26674
2021-11-11  6:06:49 0 [Note] InnoDB: Compressed tables use zlib 1.2.11
2021-11-11  6:06:49 0 [Note] InnoDB: Number of pools: 1
2021-11-11  6:06:49 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
2021-11-11  6:06:49 0 [Note] mysqld: O_TMPFILE is not supported on
/tmp (disabling future attempts)
2021-11-11  6:06:49 0 [Note] InnoDB: Using liburing

Should contain first and last line here:

$ podman exec  mdb10.6-uring_test sysbench
/usr/share/sysbench/oltp_update_index.lua --mysql-password=sbtest
--percentile=99  --tables=8 --table_size=2000000 prepare

Creating table 'sbtest1'...
Inserting 2000000 records into 'sbtest1'
Creating a secondary index on 'sbtest1'...
Creating table 'sbtest2'...
Inserting 2000000 records into 'sbtest2'
Creating a secondary index on 'sbtest2'...
Creating table 'sbtest3'...
Inserting 2000000 records into 'sbtest3'
Creating a secondary index on 'sbtest3'...
Creating table 'sbtest4'...
Inserting 2000000 records into 'sbtest4'
Creating a secondary index on 'sbtest4'...
Creating table 'sbtest5'...
Inserting 2000000 records into 'sbtest5'
Creating a secondary index on 'sbtest5'...
Creating table 'sbtest6'...
Inserting 2000000 records into 'sbtest6'
Creating a secondary index on 'sbtest6'...
Creating table 'sbtest7'...
Inserting 2000000 records into 'sbtest7'
Creating a secondary index on 'sbtest7'...
Creating table 'sbtest8'...
Inserting 2000000 records into 'sbtest8'
Creating a secondary index on 'sbtest8'...


# Adjust threads there to the amount of hardware threads available.
time is the length of the test.

$ podman exec  mdb10.6-uring_test sysbench
/usr/share/sysbench/oltp_update_index.lua --mysql-password=sbtest
--percentile=99  --tables=8 --table_size=2000000 --rand-seed=42
--rand-type=uniform --max-requests=0 --time=600 --report-interval=5
--threads=64 run



Eventually after
https://mariadb.com/kb/en/innodb-system-variables/#innodb_fatal_semaphore_wait_threshold
of 600 seconds the podman logs mdb10.6-uring_test will contains an
error like:

2021-10-07 17:06:43 0 [ERROR] [FATAL] InnoDB:
innodb_fatal_semaphore_wait_threshold was exceeded for dict_sys.latch.
Please refer to
https://mariadb.com/kb/en/how-to-produce-a-full-stack-trace-for-mysqld/
211007 17:06:43 [ERROR] mysqld got signal 6 ;


Restarting the container on the same populated ~/mdbtest volume could
be slow due to recovery time. Remove contents and repeat prepare step.

cleanup:

podman kill mdb10.6-uring_test
podman rm mdb10.6-uring_test
sudo rm -rf ~/mdbtest
