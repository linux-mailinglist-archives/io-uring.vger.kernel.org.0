Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A320BA8A
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 22:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgFZUst (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 16:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZUst (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 16:48:49 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81EC03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:48:49 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f3so5450914pgr.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 13:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wYnOfz9xTrLPqw790xjZxSHqjnEaiYO13v3PM0p4eRE=;
        b=EleRmn5bEWPmL0z92SFmagT7zMuxl95yiDT/KMlCU0B/VNJQL7razrFI7tuG4mVfWn
         CtvdOONSF/aaFNm4QMcMhmMIKpKhisirPhPmdKObsWoNrhb2gt/AJl+vgCOuadpnBVYW
         ZOzqB6BfWpYZ46WAf45WXF7zJY161deUe5zc9w2bqKsWKKBWTSQBnox4q/iAGM5hltZt
         7Mk4WR32dz9rQPQWfnYOCGd/b3V+JuQwz7fPYAC7PTzorX/0fYsPtrYecLSGzJx3EBYz
         llP6Kbzk2ewu8WYd03Tl6MHZRaqOaMjxgsCcXU2W2QInj9Ix9ss0zzAy8H86ygnoHZrk
         6/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wYnOfz9xTrLPqw790xjZxSHqjnEaiYO13v3PM0p4eRE=;
        b=XL80oU/Sjk25LVkRnD5LtyNpkkQCeeTOhPKkG4tdnmCIWzG9nYgexWthBBllNiP6nj
         tuQV3c+q1zx8QNAtpuY9OBQftAWIIBa58ZZjyq2zW8bQi9OajdR0iVy1C2UNnGuCb1aA
         +ZCY3t9GZOU+LqvGB0EoPqgKDtG1cJxOxvfXvG0vTXtEyJTSfFak8vT6/GBc+zLK7IRC
         Sg837jxD2RyVkeA3C2qxqIHJn9ec1eAEpOKDUMgEl8MY0Yz5y2GkS1TMPhI5L0Rozyfp
         npILPps/wAurxL5OXr0gHsdR+bsvTUvrO3hppWTsrroYHcwpjDo37MsFk5XljyNM+BqA
         gOFg==
X-Gm-Message-State: AOAM531i+JHTVJKJ+OjqFoRhMQ7dpBbaRTOmv60FRoB+inRmqA8ZaYBE
        NhWoc16iWuxSPaKGHv+mVrOGf1e4mM9PYg==
X-Google-Smtp-Source: ABdhPJyNVzB8i+GzRlMNotb2E8m0H8NqNGQbxvvZVATnK+4kwMXrW3eu2ktMdo3nEZNj0+Qd8iv+cg==
X-Received: by 2002:a63:df54:: with SMTP id h20mr478896pgj.319.1593204528210;
        Fri, 26 Jun 2020 13:48:48 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p8sm23513417pgs.29.2020.06.26.13.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 13:48:47 -0700 (PDT)
Subject: Re: sendto(), recvfrom()
To:     Nathan Ringo <nathan@remexre.xyz>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ef05759-92fe-8b9c-2ebf-972e7ce73817@kernel.dk>
Date:   Fri, 26 Jun 2020 14:48:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bRmxY0zzqGcGWE4Xg-O3jlU42WtEEMUb4iGvfOvesLybmoDNJ242_9phm-DHLM8zJzu7C63iKCZq4ZJLcrYXnuVewHvCgiO21tW2CSuabnE=@remexre.xyz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/20 2:47 PM, Nathan Ringo wrote:
> Would adding IORING_OP_{SENDTO,RECVFROM} be a reasonable first kernel
> contribution? I'd like to write a program with io_uring that's listening
> on a UDP socket, so recvfrom() at least is important to my use-case.

Certainly. When you hack it up, be sure to also provide a liburing
regression test case for test/ that tests the feature.

-- 
Jens Axboe

