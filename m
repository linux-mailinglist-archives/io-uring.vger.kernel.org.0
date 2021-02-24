Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0013235FF
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 04:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhBXD0W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 22:26:22 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37135 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233020AbhBXD0W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 22:26:22 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4E394D1B;
        Tue, 23 Feb 2021 22:25:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Feb 2021 22:25:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:mime-version:content-type; s=
        fm3; bh=SkwlrF64/sU/n0bpXsKe1Ej7QHljL5ym5FUC6TaGUOc=; b=eqWp1lAz
        p/CzO1tYyVkzt8rmS+GJMqrD3/cJkADlyHR7shEy5c3SaNLXe7/Zi4mbHDmpV87E
        5LEibcb9m/1Wm9lsXjNol2rPepyiaW1HG2yiwciGw4rx/YYP3kNT33idd9Xb+B3r
        XvjRS0SLCQqeLHE965lj/zSPmrpXI/ruIo5wUJUiWoKwaWimJcoSVHNraB07/kZ7
        LbdaMPJ8kf9qQQayNZDwS55WzfGTF3SgaNLN5x+QtAaBDMN+eqiz1lrzluQJqgCs
        FoGcW2BR7LcIxiClnE7ZDvKRzyqy0EBKNXiJ8Hgdg+uxYIJW67kA31QJgz9uPdkV
        4ZVMuAXVOEySwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=SkwlrF64/sU/n0bpXsKe1Ej7QHljL
        5ym5FUC6TaGUOc=; b=Qk6Eq1Ah4n4oisGjnBTafzWCR3ucZWeVuwQxeLI+KACxb
        b95edWVuy3qbYLYgXycRbZeIjK2qbIXSF7IN6VLkwHvnJ3eFbrFICudN0pLGNucl
        vH+rKu50AW6qDwFMBarrk4zrHzTVUv2FamxeWP1Ecl7EXIhX11vrjUA8DaDyLSif
        GA2mU8F8nABxxTSy/B1GyC/Zbt8YodJQcwLjhIX9AafgtVsJm09kGW/WcMGzC33H
        y+kNY2Th5ulye8mJEW/J2IUYacTlUmBVQHtwcgOPa2GAv9DZScv5iBjsgcrSbPAn
        LlF0oiRex03uY2sHya9ojrrT2EomakaatYlEV3T3Q==
X-ME-Sender: <xms:G8c1YERkHhTkYmi4Q4eJ1vbmwl6kYF1Mdl1EtLrsjlAIao3sJ7QD2A>
    <xme:G8c1YBzlq43Obpmx1fdpBFEiWp4rbMh-WzsfMhnDegmJaI8ExQDLAY2qr1hf1XOjA
    g4B6rzo3qhv8Y-uKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrthhtvg
    hrnhepiedvieelgeeuuedtfeduhfefteehhfevvdeljeetgfeugfdtledtudetvdehkeff
    necukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:G8c1YB0NODfZUgHiyg95ABiomyZkNjgsNVvbR89_N43wKEjaBk6Rdw>
    <xmx:G8c1YIAPRWDux6K5frPv9kLnG9gx1DDb9w3T4hX97BJI-jT09n1RUg>
    <xmx:G8c1YNhdmI-8jmSSv-BqWu1yS7-eXAxxdssMEty6IVVrUNGQ71chpQ>
    <xmx:G8c1YHcfRfd8UJMd__DfQHj3O2fQCatiU4J9x7S7ycdnM9iAV-95Sg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63DDB24005B;
        Tue, 23 Feb 2021 22:25:15 -0500 (EST)
Date:   Tue, 23 Feb 2021 19:25:14 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: io_uring_enter() returns EAGAIN after child exit in 5.12
Message-ID: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

commit 41be53e94fb04cc69fdf2f524c2a05d8069e047b (HEAD, refs/bisect/bad)
Author: Jens Axboe <axboe@kernel.dk>
Date:   2021-02-13 09:11:04 -0700

    io_uring: kill cached requests from exiting task closing the ring

    Be nice and prune these upfront, in case the ring is being shared and
    one of the tasks is going away. This is a bit more important now that
    we account the allocations.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>


causes EAGAIN to be returned by io_uring_enter() after a child
exits. The existing liburing test across-fork.c repros the issue after
applying the patch below.

Retrying the submission twice seems to make it succeed most of the
time...

Greetings,

Andres Freund

diff --git a/test/across-fork.c b/test/across-fork.c
index 14ee93a..2b19f39 100644
--- a/test/across-fork.c
+++ b/test/across-fork.c
@@ -220,6 +220,13 @@ int main(int argc, char *argv[])
                if (wait_cqe(&shmem->ring, "p cqe 2"))
                        goto errcleanup;
 
+               /* check that IO still works after the child exited */
+               if (submit_write(&shmem->ring, shared_fd, "parent: after child exit\n", 0))
+                       goto errcleanup;
+
+               if (wait_cqe(&shmem->ring, "p cqe 3"))
+                       goto errcleanup;
+
                break;
        }
        case 0: {
@@ -260,7 +267,8 @@ int main(int argc, char *argv[])
        if (verify_file(tmpdir, "shared",
                         "before fork: write shared fd\n"
                         "parent: write shared fd\n"
-                        "child: write shared fd\n") ||
+                        "child: write shared fd\n"
+                        "parent: after child exit\n") ||
            verify_file(tmpdir, "parent1", "parent: write parent fd 1\n") ||
            verify_file(tmpdir, "parent2", "parent: write parent fd 2\n") ||
            verify_file(tmpdir, "child", "child: write child fd\n"))
