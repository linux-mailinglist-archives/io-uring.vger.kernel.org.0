Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0CC5A64D5
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 15:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiH3NdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 09:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiH3NdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 09:33:16 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B74B2D89;
        Tue, 30 Aug 2022 06:33:16 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id y17so1518748qvr.5;
        Tue, 30 Aug 2022 06:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=h8Ro8IuNO2Gir8WKx/cG+xP2lCu4UuyaAndPwSiU8ks=;
        b=Dg8YDGG56CTeIbd09KTUeVvyvKb1O0MiNSEfT6Z7L/ZQE4rBLy2POz7F797V/VLyfX
         X1w58+xXaYHdeRDDuMo6H3qIub9+YYUIqwhtovO+p/IhTCj3mLpfxppIVKlhm74F0IM9
         H49RPpCGCf+atyPU0QzqKnkqCpCY2s58zuwfuY4C32Y7cU8QmsdLcqsJAuX/POtipzGs
         NMNeONxLsrOuVbnNmtGFOUsv0operNrfbxu7AQ1e2ViLOCJkr8YngjkNoMvjJNHBwD+A
         ibt+DUvf3rNoBLF4reR3lzMTthYqywLyq6SKKxKSNNTVbqLECcfNeeIT4efMeDbqt+3W
         DzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=h8Ro8IuNO2Gir8WKx/cG+xP2lCu4UuyaAndPwSiU8ks=;
        b=VPXRFtWQixBB1/Ep10ZhGfTDDW1bVHn8UpBU2mDrE2mcGRTBUtOye31O+6HS2vcqCR
         fuAV/Sq1+Lm2bxhk0t8PYjcrYhXpYh9C1VvHhDoTUpWZEiBQaWJuBSo0AqGTw5YnsF8M
         NdU30yJnTSftETIAdnJQSklmy8n2GGLZcpuINvVRM0BYCilLN7TWmrFeEYZM+ka7uyVj
         eRIjNmm0JYoKS7VImibd/VS8BL3Di8t6tF4EYgFe5dXygVpa9i0VcsQ+WUqDDNZDCuXi
         JE1YmgB05w8DXKGn64ELCijtAFX6EYRVa+iWfjwT/3aavBly9f/5NY9R/dU4khnZiwYl
         w4zg==
X-Gm-Message-State: ACgBeo2cIImRPff76sZJjND4cvf6b0UBz8M/nrVUWk4ddpfYvHKp9KSf
        poJ1dl60H7Q5QMjWzSJQCQ42uPX3qbyUccVN7sGOJadh+TUatQ==
X-Google-Smtp-Source: AA6agR4wZTWWCAVGtLtxwuKO6qT0R87tWfH2WlU1I/MF7dtHnVvUJKuNfOsbC//GHIpAET7lHiBZeiDcpcyxdkL2KyQ=
X-Received: by 2002:a05:6214:c2b:b0:476:813a:b173 with SMTP id
 a11-20020a0562140c2b00b00476813ab173mr14978476qvd.31.1661866395183; Tue, 30
 Aug 2022 06:33:15 -0700 (PDT)
MIME-Version: 1.0
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Tue, 30 Aug 2022 21:33:03 +0800
Message-ID: <CAO4S-me0tq289wabwsL4xbRXfHgaetqvExt8+ZyrKLxfGzLteA@mail.gmail.com>
Subject: possible deadlock in io_poll_double_wake
To:     linux-kernel@vger.kernel.org, axboe@kernel.dk,
        asml.silence@gmail.com, Qiang.Zhang@windriver.com
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using modified Syzkaller to fuzz the Linux kernel-5.19, the
following crash was triggered. Though the issue seems to get fixed on
syzbot(https://syzkaller.appspot.com/bug?id=12e4415bf5272f433acefa690478208f3be3be2d),
it could still be triggered with the following repro.
We would appreciate a CVE ID if this is a security issue.

HEAD commit: 568035b01cfb Linux-5.15.58
git tree: upstream

console output:
https://drive.google.com/file/d/1e4DHaUKhY9DLZJK_pNScWHydUv-MaD9_/view?usp=sharing
https://drive.google.com/file/d/1NmOGWcfPnY2kSrS0nOwvG1AZ923jFQ3p/view?usp=sharing
kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
syz repro: https://drive.google.com/file/d/1e5xY8AOMimLbpAlOOupmGYC_tUA3sa8k/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1esAe__18Lt7and43QdXFfI6GJCsF85_z/view?usp=sharing

Description:
spin_lock_irqsave() in __wake_up_common_lock() is called before waking
up a task. However, spin_lock_irqsave() has to be called once in
io_poll_double_wake().
such call stack is:

   snd_pcm_post_stop()
      __wake_up_common_lock()
         spin_lock_irqsave()
             io_poll_double_wake()
                 spin_lock_irqsave()

Environment:
Ubuntu 20.04 on Linux 5.4.0
QEMU 4.2.1:
qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel /home/workdir/bzImage \
  -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
  -drive file=/home/workdir/stretch.img,format=raw \
  -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
  -net nic,model=e1000 \
  -enable-kvm \
  -nographic \
  -pidfile vm.pid \
  2>&1 | tee vm.log

If you fix this issue, please add the following tag to the commit:
Reported-by Jiacheng Xu<578001344xu@gmail.com>
