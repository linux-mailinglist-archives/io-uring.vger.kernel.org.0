Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CFA173B27
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 16:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgB1PQI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 10:16:08 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:34535 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgB1PQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 10:16:08 -0500
Received: by mail-io1-f46.google.com with SMTP id z190so3791776iof.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 07:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kr/scANoPclBqA40Z4yKvOc53JA8SGG9g/n2i12EtE8=;
        b=oEHedgIvEoJH+8CmW7blnb0Mr6LQ5jaerXs76OSFtlrwG4OM0ZEdRW/ML815S1ntxB
         u5Gs4D7155T9K2xbzuajYUsdav4L21H7mVCiQN3IW946VR2ZqvcBkSh+31Xmf3dQCz7b
         IUtzFnDSXfkV2F5cK2eKvCoG+nbEX4c6xnaLNRzY/966+9Jpr1MneftCZ1TYPBM5vXZX
         U7PPWOFdtLxj73p41tga+TsqdLLGghCJ3rzO3LibvYaZQ1IsIaoIk79L7A9L6Gjpq+iT
         3kpkcagZWxSsK/9LGE4lSCef8q5CBLjuqwCgysQIwGbigaS1GPQDU/6V9baOPJ22/8B8
         wT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kr/scANoPclBqA40Z4yKvOc53JA8SGG9g/n2i12EtE8=;
        b=I0pPeqviPcVu5R9uAreVSTrO9lWf384Rr7H6HlW7VLqJkAROofs2EVpuk9oSe+c99n
         C1fY7MRcjzyFcpvH24i2AoyuAun6y0iMyhjYYcQKhYqbMgaL7ORF8/bGKv63cmrrl2+b
         fpHN/7zrFNJYmjTngsBZdrjJ/lB+LvqpnLSnTF6l1H2Iqbk9euFuhtClUzUYH5hwppRD
         Rj9nGZc87KASIRHamYXL4HIjz/BuPDcAqcuAfdJAB0oztIUjdxk6wbju9ibxECVwU6C2
         JUI7+NI6Lgiw1yb/1v4Ts2fhYY6HOExpWBmRW9E+edleP24KgqK4gXJw9tzRw9xyvTq+
         A9zA==
X-Gm-Message-State: APjAAAWYNTbvUVwNbGsJ8GuoHM/4Jj/rqVvHFzma65AYo+GqHZwaf1lS
        PJNfWnALt5Nu1vjZZNEGqHVDBw==
X-Google-Smtp-Source: APXvYqxae8UYPDehlyfptcwAaWolCpSemGR12Dhk72CDdD+KemrEQFrIHutD+K+8qRypf7+2H1RfJw==
X-Received: by 2002:a5d:9e0d:: with SMTP id h13mr579031ioh.98.1582902966285;
        Fri, 28 Feb 2020 07:16:06 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm3147239ila.54.2020.02.28.07.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 07:16:05 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: Issue with splice 32-bit compatability?
Message-ID: <ea81e4f4-59d2-fa8e-2b5c-0c215c378850@kernel.dk>
Date:   Fri, 28 Feb 2020 08:16:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey Pavel,

Since I yesterday found that weirdness with networking and using
a separate flag for compat mode, I went to check everything else.
Outside of all the syzbot reproducers not running in 32-bit mode,
the only other error was splice:

splice: returned -29, expected 16384
basic splice-copy failed
test_splice failed -29 0
Test splice failed with ret 227

Can you take a look? I just edit test/Makefile and src/Makefile and
add -m32 to the CFLAGS for testing.

-- 
Jens Axboe

