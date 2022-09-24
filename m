Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5B5E8DC2
	for <lists+io-uring@lfdr.de>; Sat, 24 Sep 2022 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiIXPQa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Sep 2022 11:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIXPQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Sep 2022 11:16:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEB2AF4B5
        for <io-uring@vger.kernel.org>; Sat, 24 Sep 2022 08:16:28 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso8620341pjk.0
        for <io-uring@vger.kernel.org>; Sat, 24 Sep 2022 08:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=AdfQwNWcnmTTArFW485F984NEqY0O7HrvFRT5JRQAL0=;
        b=oP/FYrSnEpWO8ZNGc3ezgOpAD+JGQvm4r0euuKxPX7mMoxEtO6phk0nrPHfs1aXzpn
         md+tWEMutbhxGofaGHNddz7zjZtQjedXiJxQQ9WtRSErZOVNdnbrZSByDKgAHZks76fG
         +9IDj1wI6M3fFCdDl6+2yWWOPaZO/4ZBVaRQWIVMDSeWXmFqpGqnOvRerjvaQqsMUdHd
         Yu5h7+DAn1TFc8bkWprTtDU/tt8zOuD8Hyc+OrED5W1PiZM4cPOFni+QB1rmOW/ZsQ5x
         CZK3E4Xv28/rsdtbZtCxj/ASWoWm3AJOW0JoKu3if1GYg+OTjydmdfVO/IqRckKWCYOw
         +mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=AdfQwNWcnmTTArFW485F984NEqY0O7HrvFRT5JRQAL0=;
        b=O9s0Y9GAlpsMtx5LVBzs6Sl7EXnDm1ep/Zu5jiL+M+Z4OHUDrZLbKOPNrN+BmtEEx2
         DGd32zecAXbSXRhhwV7qB6a+d9cMq6HBjwlOT4tQeoca7hEf3bmj/LgMzeMFMmCr5ag+
         5IjHX5i6CGlFQ8rwV6ZC+ZS3F7ISyOM+Ldy934Ouz2eCr1cXpcXJnUFZlZ+WHH1yvrVo
         LqYCrzDKuvw+pQLqcjw1ZTiYAM25basP6Fsy9JIkCr5KVziSMSFQcdTpT/nECCMly6ar
         bgnPZJmGjinC79Fg/HnbTt4uq7b7pG7KXvfEElFQIIKayFmM9tfDSVgVfPY1L5Q+xskN
         MCnQ==
X-Gm-Message-State: ACrzQf2Y2PS5l3taUelSpnW9Yl9RaxmA9Hp95lb7sKjtQsmcT3Duxhec
        HTxKTD8SKLSYK7tfcoiL/B8aJo2qZqAsyg==
X-Google-Smtp-Source: AMsMyM7hTh4AbWi9kYb/N7nBQP4rz4lT6w/HYf6x+GoGaiibXhZbiZ1X05F9Xir3yQP2YXs7CBM9Xw==
X-Received: by 2002:a17:903:1c1:b0:178:1c92:e35 with SMTP id e1-20020a17090301c100b001781c920e35mr13533266plh.151.1664032588282;
        Sat, 24 Sep 2022 08:16:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l10-20020a170903244a00b0017532e01e3fsm7940742pls.276.2022.09.24.08.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Sep 2022 08:16:27 -0700 (PDT)
Message-ID: <42041d05-9106-686a-dd4b-f9cc03ede480@kernel.dk>
Date:   Sat, 24 Sep 2022 09:16:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.0-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix for an issue with un-reaped IOPOLL requests on
ring exit. Please pull!


The following changes since commit 9bd3f728223ebcfef8e9d087bdd142f0e388215d:

  io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC (2022-09-18 06:59:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-23

for you to fetch changes up to e775f93f2ab976a2cdb4a7b53063cbe890904f73:

  io_uring: ensure that cached task references are always put on exit (2022-09-23 18:51:08 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-23

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: ensure that cached task references are always put on exit

 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Jens Axboe
