Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107AB2AC33A
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgKISIq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 13:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKISIq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 13:08:46 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFFDC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 10:08:46 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id x20so9145226ilj.8
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 10:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j47aCS29776hDsXzBL5Yato2CFnib/+OBUg4G/BADhg=;
        b=OaLO5QPX4GFQhPXneAkdIQLvlkZ6S/SqSMH5aC6AKlbOb8oEh23O047VONbDWDo4vm
         7DaanMHctyjub7jt3JnIUY0m7MXYHx13U+Zj4cUn4qyMR7YBqBCBV9tsoSMMdShUFvTZ
         UpzIPsvJjjQwsArjfnOitmP3EPzpzHZXPq2+WLzE1xJnC5OngZ0pE9LU0OXtv7ahXLxT
         yrFq6DFO+zOj3C64NqKYprcDi9vNOS6bveANJsfX7TZETmko76lP/O/eWPHukDo+IAIA
         PutdVIfcTKYzGdGKWN5KQJflVlB5VheL7tvr1MMWx3KM6xPK65H1+agvbjBgjm2JtP4S
         AzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j47aCS29776hDsXzBL5Yato2CFnib/+OBUg4G/BADhg=;
        b=U3a1R0eE8n5kLQ/8D3VD7DnxG62nhRK7vOd1P7iSRDUb4YzRtxMzszBJyfGiSBdjuB
         yFKtB0SIafobQXPYwV2SJt3HaDtKwyHJjEHhY5CD34q0sfZfslUXLyBkNfPsS7R7PSlX
         dEmmwwZbjo8VlHFMMQdopZBd0EtrUqATJZ379Or8+jQV5ongbepQdBKFhCUyZMLnpP7o
         hh/AFjR3XiiI5ADRQk2VuEaHqT5LCQjlyMcVPzePttpW9cUmnU0dLmVUw97AduuwHkNV
         KqJUmLbHlpK4oULP3esWEMo18IbghlyTndj6FU5QrFr8NtzBpe9WpJwBuiYv1a9RPRY9
         EP4A==
X-Gm-Message-State: AOAM532/u6qJ7RgcCWyNdICKs2vdFWto/cGQ1c5TTkQGdi79MdsEVsDf
        Xwss+Pmo5Q25fGhmm8sqUn5p5g==
X-Google-Smtp-Source: ABdhPJy5w6MmOQcsBjeteqExZt3kI6+IfQSGLHX68AfxXahU++pOfbmyfo3sEuMDpf2Vc0iZr5zK9g==
X-Received: by 2002:a92:d3c1:: with SMTP id c1mr11449523ilh.271.1604945325477;
        Mon, 09 Nov 2020 10:08:45 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a13sm4036704ilh.0.2020.11.09.10.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 10:08:44 -0800 (PST)
Subject: Re: KASAN: slab-out-of-bounds Read in io_uring_show_cred
To:     syzbot <syzbot+46061b9b42fecc6e7d6d@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000028115c05b3b06bbd@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3f69180-187b-6801-b74c-a22231323049@kernel.dk>
Date:   Mon, 9 Nov 2020 11:08:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000028115c05b3b06bbd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dup: general protection fault in io_uring_show_cred

-- 
Jens Axboe

