Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED7718333B
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2020 15:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCLOfd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Mar 2020 10:35:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33011 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgCLOfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Mar 2020 10:35:33 -0400
Received: by mail-io1-f65.google.com with SMTP id r15so5911772iog.0
        for <io-uring@vger.kernel.org>; Thu, 12 Mar 2020 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Q4FiQLXhjwStZmOYzHQGfmnzPhLI0zvMi+wXTYLHpTk=;
        b=Cm60S2dWe8JeJkat+EMyGodxi2i2wiUkKIZy7EHVeo9mTS15Tpb57ERxbwzulv7UDu
         Ft2N6+TI5UPC344muYxQk4MCjyfeRLvhY7oSpL0I6dgCiHG5zRM8bVVBUXbRzr6a7XpL
         uXzPEzJLYoiwFQETYmhPHWPWdAJbrwsKlc50PlIjqWHbQObsC8M4HZaIisDGUkgvWqHi
         0eQKYdl7KiTGNbUXzcvSDzm8lCwDxFsDzgaSbKVxxvbmY05thnX9YAHQ7iuHq+kb7z5e
         uRDW67gmW9J18Y8PsE6Gc942nGaRbX7XiS6x5T3er7G3cQ3DbWGQ0el3pOSC0JEUNKAJ
         KGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q4FiQLXhjwStZmOYzHQGfmnzPhLI0zvMi+wXTYLHpTk=;
        b=I8otBh1LMkX9yj4BduDuMUCk4qpS7ki73FZ85upf/pnJ9U4S8+RlUHJCuul2aT1MJs
         2H+2a/kexuyuulcqdvFxpdlG+NwF6okeiHi3VJ2MK5jlU5dgY43dQdIuHoIsXdLN4ZL6
         gfJL27SuzR/O8p7D9GsRMMxSFBg9yL5d82LAutl5XYNy4K/iHcgKnoDBmBjgXL5fIxSe
         I7RbNbGHOKouJVn+Yeu/578q+lBTvVEPF7+qcGVpf8EKjYcSkK/r5Z8VsRxc0XJF2vz+
         MAG/qcNreykaM5xiQN0RoaENVmUMp6CHPiafQDeiQu/hFFrT7PGWmS7G+9yt4B3pwALI
         Qtdw==
X-Gm-Message-State: ANhLgQ2eUUhbiE+oHP+tDT7DaiQyyzb1+JxwwlPj3IbNwa8+6ljbw5Jv
        7DPBGrmBuPlMv1npYomuYLmTrQ==
X-Google-Smtp-Source: ADFU+vslzlUjaqbM05REXlsAewd1RXt/CcCOlTCgp8fwLTiBQ3Vzrnpkj9AMeaqpMuXQBxwXlhuJkQ==
X-Received: by 2002:a6b:7407:: with SMTP id s7mr7988540iog.11.1584023730700;
        Thu, 12 Mar 2020 07:35:30 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x7sm8719674ill.19.2020.03.12.07.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 07:35:30 -0700 (PDT)
Subject: Re: [PATCH 1/1] io-wq: remove duplicated cancel code
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <883f200570ee22c8081469bd571bec5fb27da4c5.1583531319.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <277bb693-d5ad-b021-7ea9-d935f878215f@kernel.dk>
Date:   Thu, 12 Mar 2020 08:35:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <883f200570ee22c8081469bd571bec5fb27da4c5.1583531319.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/20 3:15 PM, Pavel Begunkov wrote:
> Deduplicate cancellation parts, as many of them looks the same, as do
> e.g.
> - io_wqe_cancel_cb_work() and io_wqe_cancel_work()
> - io_wq_worker_cancel() and io_work_cancel()

Looks good to me, and passes my initial testing. Applied!

-- 
Jens Axboe

