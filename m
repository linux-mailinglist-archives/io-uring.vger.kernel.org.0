Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C869933B1E5
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 12:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhCOL5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhCOL5r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 07:57:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654A1C061574
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 04:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=vfQ5J4YMZ7gX9VjUlbh4cVpvdbMoyptMTc9vXBrvKfA=; b=GUwxnY4QC5Ga004GIWMomZLMLJ
        vlcvMTJmMKha55hal0XaoBm2IycjCJ1VMCBNaK3DjhT6kvtaPsqz1y/aTixfxTj7hPrM3tIhvhwoG
        4+MfFu3CJXW1BbLd6v+DU++sNWMmlPgDL8NgGGz9wHnvNd8FHJO+q+W16SU5fkyN/rgA8vQQdV0rY
        vbuy0A5qGhqoytP/7f4C7HWnFiwXkufFw+So9QaVRT7yENHNdrh1nEXTJvkHn5YFr9c30HmdVWx3f
        zxU+7dO6k+RUYjgRR/UvCmdW0i9kwlsjN6T8MSIONXlGiK2eMUSGuz0w/JO3QHe2RRXNRTY6EsDqt
        SUYkP47boHpENqV1nFL9OQUKh0J8bW6D7sxncEM1INA1aP+HNI4b8UAsxEkkoPs/8GLNIj+XTO8C8
        4K2nwKhaa24Aizo9pUtthDLFlZsPoOLazhp33AiOMb9pjyswwKqoGOmcbimaCkflDacPSRktnBAmi
        QonbCBHxnnOFyuGWUS9I0YZv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLlqx-00029y-Gb; Mon, 15 Mar 2021 11:57:43 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 0/2] Some header cleanups
Date:   Mon, 15 Mar 2021 12:56:55 +0100
Message-Id: <cover.1615809009.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
References: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

here're a few cleanups in order to make structures as private and
typesafe as possible. It also cleans up the layering from io_uring.c
being on top of io-wq.*.

Changes since v1:

- None, hopefully correct patch format now.

Stefan Metzmacher (2):
  io_uring: remove structures from include/linux/io_uring.h
  io_uring: use typesafe pointers in io_uring_task

 fs/io-wq.h               | 10 +++++++++-
 fs/io_uring.c            | 16 ++++++++++++++++
 include/linux/io_uring.h | 25 -------------------------
 3 files changed, 25 insertions(+), 26 deletions(-)

-- 
2.25.1

