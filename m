Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1454B3331E8
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 00:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhCIXeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 18:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhCIXeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 18:34:36 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5AAC06175F
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 15:34:35 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id j12so10644642pfj.12
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 15:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=jiSiFglQmxZEJ5Wo/V77lv2N41tEqlwbI7v3epkgItw5xYfXGxlauBpw9uzfeKRy9T
         UgWtMw/oXm8AuRgak2BKRl5XhK5zcUO2837WG2rF2W8MM8EvE6UpNPAWncenkj0VYlKH
         Wn+42kDb50QvRqsESQ2mom+sK8P9ZkVKhJUlfw17R8MaXfwzjUrcUKKhMatHk8l1n8z6
         HORyhRzzkFREwaIywpdXqw9NNouEzJ8obgGp95ES0SB4Z7kZ2Uf5tkrCu65jYV/wXqtc
         UCWEZCt7cJx4Cy1bJj+/BoOSmvIjqkxbeU85OG1e7JJ+tuq+pIzZNNEJVKCnsblb6lrn
         0mOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=Maz8zNR83I5pJP9OZkDZRsk3GfiHqPjdjnfMYHWn2NW9p011/KT9Vt7W3bBTxM/1Np
         t3s9cfp1Nyz81qkLnoINJw8yfKJ9vk2kH5lsOHCBC4hGqhr9kofODDML85f4BNfk43NR
         TV26+1QQzoznkjKMfGFzRx6R8roTOl2opKEIaMG/cQLLFJAr/1Qzl3nUFIk5phdZE4CH
         bbgCwo/f4hyfTAHEPThxZGsg2NYUmzk2clKjHvBiOGREvKcEpbWT8urxigUXZqGVsZel
         ew7wDWFi8SqYvpxvj9XIJ6AGNohVFURTKPw41+JgWkf7UbEOn41OKBnNLLzKKWR2HFJO
         zmCw==
X-Gm-Message-State: AOAM531lx9IrXUV40x2a7cavOQhkC8g/5qk8iN7AfNWzU9UrDzrvCxwy
        ZQBCixLf5xjVwxA3/mt9Ucl9/ovAHO7amw==
X-Google-Smtp-Source: ABdhPJzfKS6kURnpgZPykAhAOJiKpUELYKYWDREb1RpAet6KiUSXO4LXfgtQd3YCjbxFWOuA+4TjfA==
X-Received: by 2002:a63:1946:: with SMTP id 6mr175679pgz.359.1615332875151;
        Tue, 09 Mar 2021 15:34:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y68sm15546218pgy.5.2021.03.09.15.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 15:34:34 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
To:     syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000023b36405bd221483@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <179d05df-3c1f-1609-b941-a737f8fb13e0@kernel.dk>
Date:   Tue, 9 Mar 2021 16:34:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000023b36405bd221483@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block io_uring-5.12

-- 
Jens Axboe

