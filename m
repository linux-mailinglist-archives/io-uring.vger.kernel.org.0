Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D395E4D3DBC
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 00:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiCIXuL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 18:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiCIXuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 18:50:11 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5FD11C7C4
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 15:49:11 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id s25so6511228lfs.10
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 15:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=eaMRnJWRZaMycUZdpvL5QLW+AGCkesCF7E8MDz4o5Bk=;
        b=RtnEWQPn11LLP5NdJOCZLj8rwOEiy1m5Ft4PpSaRyXoCy8yjiE2tCvsSThRL5GYs7K
         ROtAv7/chky+LKyO46gYUbtGesHK1tLyuwFQr40apPlAHw9+Ob2/MrPcccc3rVYpkl1P
         lEZsBtpcx3zF7IFPLRiO/rSsIMMNgC0Tt5GfIJtOGw5U3r4RW7Zjbfcd0bIi0iGzBMI4
         mD8I8URRQUuMmJt1cDMX4hPvF2n5CJrt7u6e7YMEK7uB4OvvroufsEz97CUJ7YnwtL2L
         ZDQeKadtmcDRdFAkpObvRbIacKVTv8gDzbD9Oz6clHpgpoHnFeO6UFCJs5RdJ3P4mJGH
         PC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=eaMRnJWRZaMycUZdpvL5QLW+AGCkesCF7E8MDz4o5Bk=;
        b=XOx5ZKIuJqBjq3aVxlTCQfsvdLjj1fUnJmnaIwxdRCYYdxM4iktDl01Zh+BOmB18T6
         zrwIbxmDG+y0eiiZRfWhfyY6FNYkdSxHuLfBmkVnEQJpAI2EUCym+3tMXHstjNy+Or/9
         n7adUkATr8qEJWWsC5XV5L5PLmwllhzecvGkHnx9ltUipj+XU4pigQYDlwnturdXCPyW
         5RnZY4b0eGtsmd57lxhFIVkNFKfmdVVqgIKylsC3KRbuOOg6PYyc/Pt5pj3tIGGK8vly
         5pwupgfkXp+BpoQ3TdJi1GI8MV6qvDUBBToYpQKvPYDBoT+8iljuOxovpcSMPR/neWWP
         7k3g==
X-Gm-Message-State: AOAM531ymzfyUWaopSAiooSSCOEy2FYIQ0FTUjc7xVydmNVchPZbN54n
        wZXE+z9+qiu8OEZObEQV/qw9r2wTKA==
X-Google-Smtp-Source: ABdhPJw9b/cbgyYslRZH1yVPBNlKFtMB6xwdR/biSh92o+mkyKBzTuDeG+2UCYW9jc2JOoi+KdsM6A==
X-Received: by 2002:a19:f80c:0:b0:448:26dc:4f8b with SMTP id a12-20020a19f80c000000b0044826dc4f8bmr1320170lff.25.1646869749218;
        Wed, 09 Mar 2022 15:49:09 -0800 (PST)
Received: from [192.168.1.140] ([217.117.243.16])
        by smtp.gmail.com with ESMTPSA id bt23-20020a056512261700b0044400161095sm647577lfb.168.2022.03.09.15.49.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 15:49:08 -0800 (PST)
Message-ID: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
Date:   Thu, 10 Mar 2022 02:49:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring@vger.kernel.org
From:   Artyom Pavlov <newpavlov@gmail.com>
Subject: Sending CQE to a different ring
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings!

A common approach for multi-threaded servers is to have a number of 
threads equal to a number of cores and launch a separate ring in each 
one. AFAIK currently if we want to send an event to a different ring, we 
have to write-lock this ring, create SQE, and update the index ring. 
Alternatively, we could use some kind of user-space message passing.

Such approaches are somewhat inefficient and I think it can be solved 
elegantly by updating the io_uring_sqe type to allow accepting fd of a 
ring to which CQE must be sent by kernel. It can be done by introducing 
an IOSQE_ flag and using one of currently unused padding u64s.

Such feature could be useful for load balancing and message passing 
between threads which would ride on top of io-uring, i.e. you could send 
NOP with user_data pointing to a message payload.

Best regards,
Artyom Pavlov.
