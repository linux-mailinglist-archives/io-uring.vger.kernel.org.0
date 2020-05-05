Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC01C5C15
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 17:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgEEPok (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 11:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbgEEPoj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 11:44:39 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B995FC061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 08:44:39 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id m5so2673686ilj.10
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 08:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XvQuDAbxCT3zphV0ysYVc3s9Uusu/7B018m4dOVLu5I=;
        b=Pikau3k7hF7f8hxS2J+iPMEi9Flp2qWZPUpltRSCmgevYBK5Vcd5X71G4F1xvPhl3D
         fwZdKd4GOiTFSz9hky/91qVhY6uC2/7ZlRksv4wsAMdYl/w5HipD+9Sxi9VO3eRhMAFG
         5yYMitBVniChlaU4SmTtbUxGpWdR/zB4dWvdb7kREk0CWUyqFEQUNNoLqr3H2SgiPxsN
         43VW19v6lnSKktgDrxVORHOev6DgjitN/b60Y554soFnp+whXZD/va4V4mknArC5Yh7Q
         Mp25Bjs+mjsIddUz9VBEGPeFJJCfcJmf3x20R1t45giy9HC+wK+GkXddqN0wsNKrom/+
         EiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XvQuDAbxCT3zphV0ysYVc3s9Uusu/7B018m4dOVLu5I=;
        b=ZKQ9Wc0O/5f9IOXqglxMNsFE4Psw/7K7AZ8tZcZQscz4TIGikSHPPnvYfq8cUPij1M
         ra6jqvVpnlpf6oMoUfZNIJQa3XPGxXe/4Pbui1k0FvCHGka+hnElnyWpwjf2H3WsCj9L
         S6IqH7Qhp4GomlQfYY1HFn9H/ZOun5aL7qRp01D9aWfISdLWXAT9jt1gm1ELI6wxHKzv
         KaKXU+0Yt7xz1GHLaG+c160fYyXUkrExFFuzo6EbrpfugG/QJL/b8Ugym9GLO2XjaOzH
         nnuNdPZn3YbJ/uTq5A45XrlexesltYbyzDtEVXBAjuxvT8AimB3zGMy/bOZbKFFnrM5w
         u7RQ==
X-Gm-Message-State: AGi0Pubbxao+t+SPqV5yNpwB5bLkhE0rMjbp5bi9GGKWuCQ6FnZWcn5B
        ulfclwc0VSgqKZEdjTExTIESYp8qAnG49A==
X-Google-Smtp-Source: APiQypI1vi1pjaV0d4+fZuTtOct11H6ueRprC0SP/dhwPSm9UoCQvBmGAUkMPfdNXvmA35qLcjMrYA==
X-Received: by 2002:a92:858b:: with SMTP id f133mr3859463ilh.97.1588693478163;
        Tue, 05 May 2020 08:44:38 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s81sm1949740ilb.60.2020.05.05.08.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 08:44:37 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
Message-ID: <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
Date:   Tue, 5 May 2020 09:44:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 8:41 AM, Jens Axboe wrote:
> On 5/5/20 4:04 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>> we currently have a bug report [1][2] regarding a data corruption with
>> Samba's vfs_io_uring.c [3].
>>
>> Is there're a know problem in newer kernels? It seems the 5.3 Kernel
>> doesn't have the problem (at least Jeremy wasn't able to reproduce it
>> on the Ubuntu 5.3 kernel).
>>
>> Do you have any hints how to track that down?
> 
> I'll take a look at this! Any chance Jeremy can try 5.4 and 5.5 as well,
> just to see where we're at, roughly? That might be very helpful.

Trying to setup samba in a vm here to attempt to reproduce. I'm a major
samba noob, running with the smb.conf from the reporters email, I get:

[2020/05/05 15:43:07.126674,  0] ../../source4/smbd/server.c:629(binary_smbd_main)
  samba version 4.12.2 started.
  Copyright Andrew Tridgell and the Samba Team 1992-2020
[2020/05/05 15:43:07.152828,  0] ../../source4/smbd/server.c:826(binary_smbd_main)
  At this time the 'samba' binary should only be used for either:
  'server role = active directory domain controller' or to access the ntvfs file server with 'server services = +smb' or the rpc proxy with 'dcerpc endpoint servers = remote'
  You should start smbd/nmbd/winbindd instead for domain member and standalone file server tasks
[2020/05/05 15:43:07.152937,  0] ../../lib/util/become_daemon.c:121(exit_daemon)
  exit_daemon: daemon failed to start: Samba detected misconfigured 'server role' and exited. Check logs for details, error code 22

Clue bat appreciated.

-- 
Jens Axboe

