Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5647C2798CB
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 14:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgIZMWo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 08:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZMWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 08:22:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65940C0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 05:22:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q123so343009pfb.0
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 05:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=F34DFOadLWUrYUexx9pZf+zYffic8Ay3o02O0h/KIN0=;
        b=yWd0yq3YHHskIvoMRtbQ+LLAOZIcKE988hjYIBBtj5ujteIZQBkaNMz/0OsbdtRcmO
         pN2KizU1b2bryab8cf67QfV69YIxkuEMPMh1TUzgn775BqS3W6LZpB1x+9CZMhjYk4W6
         sPSAKx0/iOQ7ofh7377FEjBJL68tXAjnbiNFHE5DgoIklvA5Swpw7LkkVMhEWhM0K+bg
         ylTt8IJ58qrBp/cC2SpkhTmQ3IGS9l1Si2eUUhIZBThh+EP2DAyRCw0p83NiPO8mwh1Q
         zd6Xp1j7KSjHLY5hJ4OVqE02X063t0JvqAZ/GayAyMT70nvUeP3miTr/s+OUyw/sjEmR
         AVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F34DFOadLWUrYUexx9pZf+zYffic8Ay3o02O0h/KIN0=;
        b=ZqK9s95uQxoIHrLEFywC7P4nlAuHPjU3u2vJzW3n+cWx3IPotBeepxeZ+XSj48hqZD
         /7x8HJOeZlgtMVfwRzQOW1nTyqCiTQyxTOHAU9x/JcSo4ZNpC0J45HGLzib/DdtpWYOF
         cTfO2G4WWgaWeiV+W1INEWs56LBhSxp0i6JOZlCF/wcgvhYkx9f/2opygq513WwbJRod
         Avrr66kX2wN+RlNLotsLF/1QUbwPOmGsyXOMtOiBX8gUZmfd3tgzKb4ldTnAzdy+WNPk
         Mv2QNM5EAYWw6FMfr15iHUoRUO3h6nYI2g1vfDdA0eI+x478oWnS4v6xQeIzMnfuvqxo
         xNBQ==
X-Gm-Message-State: AOAM530C3t4KIY/lXLlndt7RIVSpn9w2zvrpTNC+VCLwOn0D303uUnkj
        fgMh1GKsu8AtRRPgIyxsc+GfZQ==
X-Google-Smtp-Source: ABdhPJyqyDXGRY3HHGNq4L/5hAyvnwhoGU6nwNkDk05eIVRflSVQyikoXVsN792SpquRU5XtVXDy/w==
X-Received: by 2002:aa7:8051:0:b029:13e:d13d:a04e with SMTP id y17-20020aa780510000b029013ed13da04emr3413139pfm.20.1601122963787;
        Sat, 26 Sep 2020 05:22:43 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a18sm4682471pgw.50.2020.09.26.05.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 05:22:43 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_wqe_worker
To:     syzbot <syzbot+9af99580130003da82b1@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000007e88ec05b0354fdd@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aa342b42-8bbc-059d-46bf-0ee694c3f67d@kernel.dk>
Date:   Sat, 26 Sep 2020 06:22:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007e88ec05b0354fdd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block io_uring-5.9

-- 
Jens Axboe

