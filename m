Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C71C280E16
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 09:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgJBHfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 03:35:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgJBHfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 03:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601624110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fnU+IOGvc3pSPHiHxqEALo+mCsruplku0v8NMmQL9Bw=;
        b=TbFEZJZD7Eve0RFm/LaOnFeJCSO8OpaU2kCyvKs4x+ADAalxQRJOOABIJEqpYqYHNeQeKi
        UAJ2bb5BMQoWf7Je1Vwqy0i4MqqGOyPXmYX2aUbG8ink8zi0qcZgvgY3EwlXgk0gtWRwMk
        hTCx6i2Gxt5yVgCSsEjdNK98XC+SZ6U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-wPpOPw0iMdagfMqs_RidYg-1; Fri, 02 Oct 2020 03:35:01 -0400
X-MC-Unique: wPpOPw0iMdagfMqs_RidYg-1
Received: by mail-wm1-f69.google.com with SMTP id x6so235757wmi.1
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 00:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fnU+IOGvc3pSPHiHxqEALo+mCsruplku0v8NMmQL9Bw=;
        b=I2ZC1mSEyHuioNEfgmmzLHjTlubr1jdG3oQUFTkiRwqlY7vbmexF8pbZ3MwrVz3Rb8
         o3Dbc4VMIjnQffxck3r2xH3/2lzHIckarHLH9ZnXwd/2N4Gquj60zhJCYIHEPDMAxN6K
         3pCTMe1uzBZfveDmCgib2JqJiG6+Q/7j5nSYUGvdF3JADyR6grUdZt9WNWKGgwxDs+kn
         AjF3MbIEdd0u7IH88oNppuw5QnJYSNzXho56asCdKZv6NkVkpmxwwD+zEtR2dcUBuz/j
         fKXEz4AE/OlWMpaD6XsGpc3VmoU+qiAIl7bYHG6PY2DHG/JmXAjaeCt7dnJ14nno/+AQ
         l3RA==
X-Gm-Message-State: AOAM532S6TvDrfw+IJ0qXfZH61vUcG6PGOAF8Hf5GzEW74oMdnYhDU9q
        glUWOa3l1lblCC0OPDWqStqknPlkR0mVxme2cPrGkVFY3ONdKCbouuHmxZ5HxhdRMSk+F/jMFyD
        koFyMJxXpp60p5ZQELIk=
X-Received: by 2002:a05:600c:22c5:: with SMTP id 5mr1315258wmg.34.1601624100628;
        Fri, 02 Oct 2020 00:35:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzMBKKBBNkc0ohKpB95hgvY5gE8aBYAF+r4Fhl+DemnPV0/O9rE+hfuyYIV6r+RX1doafvxA==
X-Received: by 2002:a05:600c:22c5:: with SMTP id 5mr1315242wmg.34.1601624100328;
        Fri, 02 Oct 2020 00:35:00 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id m10sm795455wmc.9.2020.10.02.00.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 00:34:59 -0700 (PDT)
Date:   Fri, 2 Oct 2020 09:34:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Ju Hyung Park <qkrwngud825@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        qemu-devel@nongnu.org
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
Message-ID: <20201002073457.jzkmefo5c65zlka7@steredhat>
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat>
 <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ju,

On Thu, Oct 01, 2020 at 11:30:14PM +0900, Ju Hyung Park wrote:
> Hi Stefano,
> 
> On Thu, Oct 1, 2020 at 5:59 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > Please, can you share the qemu command line that you are using?
> > This can be useful for the analysis.
> 
> Sure.

Thanks for sharing.

The issue seems related to io_uring and the new io_uring fd monitoring
implementation available from QEMU 5.0.

I'll try to reproduce.

For now, as a workaround, you can rebuild qemu by disabling io-uring support:

  ../configure --disable-linux-io-uring ...


Thanks,
Stefano

> 
> QEMU:
> /usr/bin/qemu-system-x86_64 -name guest=win10,debug-threads=on -S
> -object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-win10/master-key.aes
> -blockdev {"driver":"file","filename":"/usr/share/OVMF/OVMF_CODE.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}
> -blockdev {"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}
> -blockdev {"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win10_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}
> -blockdev {"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}
> -machine pc-q35-5.0,accel=kvm,usb=off,vmport=off,dump-guest-core=off,mem-merge=off,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format
> -cpu Skylake-Client-IBRS,ss=on,vmx=on,hypervisor=on,tsc-adjust=on,clflushopt=on,umip=on,md-clear=on,stibp=on,arch-capabilities=on,ssbd=on,xsaves=on,pdpe1gb=on,ibpb=on,amd-ssbd=on,fma=off,avx=off,f16c=off,rdrand=off,bmi1=off,hle=off,avx2=off,bmi2=off,rtm=off,rdseed=off,adx=off,hv-time,hv-relaxed,hv-vapic,hv-spinlocks=0x1fff,hv-vpindex,hv-runtime,hv-synic,hv-stimer,hv-reset
> -m 8192 -mem-prealloc -mem-path /dev/hugepages/libvirt/qemu/1-win10
> -overcommit mem-lock=off -smp 4,sockets=1,dies=1,cores=2,threads=2
> -uuid 7ccc3031-1dab-4267-b72a-d60065b5ff7f -display none
> -no-user-config -nodefaults -chardev
> socket,id=charmonitor,fd=32,server,nowait -mon
> chardev=charmonitor,id=monitor,mode=control -rtc
> base=localtime,driftfix=slew -global kvm-pit.lost_tick_policy=delay
> -no-hpet -no-shutdown -global ICH9-LPC.disable_s3=1 -global
> ICH9-LPC.disable_s4=1 -boot menu=off,strict=on -device
> pcie-root-port,port=0x8,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x1
> -device pcie-root-port,port=0x9,chassis=2,id=pci.2,bus=pcie.0,addr=0x1.0x1
> -device pcie-root-port,port=0xa,chassis=3,id=pci.3,bus=pcie.0,addr=0x1.0x2
> -device pcie-root-port,port=0xb,chassis=4,id=pci.4,bus=pcie.0,addr=0x1.0x3
> -device pcie-pci-bridge,id=pci.5,bus=pci.2,addr=0x0 -device
> qemu-xhci,id=usb,bus=pci.1,addr=0x0 -blockdev
> {"driver":"host_device","filename":"/dev/disk/by-partuuid/05c3750b-060f-4703-95ea-6f5e546bf6e9","node-name":"libvirt-1-storage","cache":{"direct":false,"no-flush":true},"auto-read-only":true,"discard":"unmap"}
> -blockdev {"node-name":"libvirt-1-format","read-only":false,"discard":"unmap","detect-zeroes":"unmap","cache":{"direct":false,"no-flush":true},"driver":"raw","file":"libvirt-1-storage"}
> -device virtio-blk-pci,scsi=off,bus=pcie.0,addr=0xa,drive=libvirt-1-format,id=virtio-disk0,bootindex=1,write-cache=on
> -netdev tap,fd=34,id=hostnet0 -device
> e1000,netdev=hostnet0,id=net0,mac=52:54:00:c6:bb:bc,bus=pcie.0,addr=0x3
> -device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x4 -device
> hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -device
> vfio-pci,host=0000:00:02.0,id=hostdev0,bus=pcie.0,addr=0x2,rombar=0
> -device virtio-balloon-pci,id=balloon0,bus=pcie.0,addr=0x8 -object
> rng-random,id=objrng0,filename=/dev/urandom -device
> virtio-rng-pci,rng=objrng0,id=rng0,bus=pcie.0,addr=0x9 -msg
> timestamp=on
> 
> And I use libvirt 6.3.0 to manage the VM. Here's an xml of my VM.
> 
> <domain type="kvm">
>   <name>win10</name>
>   <uuid>7ccc3031-1dab-4267-b72a-d60065b5ff7f</uuid>
>   <metadata>
>     <libosinfo:libosinfo
> xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
>       <libosinfo:os id="http://microsoft.com/win/10"/>
>     </libosinfo:libosinfo>
>   </metadata>
>   <memory unit="KiB">8388608</memory>
>   <currentMemory unit="KiB">8388608</currentMemory>
>   <memoryBacking>
>     <hugepages/>
>     <nosharepages/>
>   </memoryBacking>
>   <vcpu placement="static">4</vcpu>
>   <cputune>
>     <vcpupin vcpu="0" cpuset="0"/>
>     <vcpupin vcpu="1" cpuset="2"/>
>     <vcpupin vcpu="2" cpuset="1"/>
>     <vcpupin vcpu="3" cpuset="3"/>
>   </cputune>
>   <os>
>     <type arch="x86_64" machine="pc-q35-5.0">hvm</type>
>     <loader readonly="yes" type="pflash">/usr/share/OVMF/OVMF_CODE.fd</loader>
>     <nvram>/var/lib/libvirt/qemu/nvram/win10_VARS.fd</nvram>
>     <boot dev="hd"/>
>     <bootmenu enable="no"/>
>   </os>
>   <features>
>     <acpi/>
>     <apic/>
>     <hyperv>
>       <relaxed state="on"/>
>       <vapic state="on"/>
>       <spinlocks state="on" retries="8191"/>
>       <vpindex state="on"/>
>       <runtime state="on"/>
>       <synic state="on"/>
>       <stimer state="on"/>
>       <reset state="on"/>
>     </hyperv>
>     <vmport state="off"/>
>   </features>
>   <cpu mode="host-model" check="partial">
>     <topology sockets="1" dies="1" cores="2" threads="2"/>
>   </cpu>
>   <clock offset="localtime">
>     <timer name="rtc" tickpolicy="catchup"/>
>     <timer name="pit" tickpolicy="delay"/>
>     <timer name="hpet" present="no"/>
>     <timer name="hypervclock" present="yes"/>
>   </clock>
>   <on_poweroff>destroy</on_poweroff>
>   <on_reboot>restart</on_reboot>
>   <on_crash>destroy</on_crash>
>   <pm>
>     <suspend-to-mem enabled="no"/>
>     <suspend-to-disk enabled="no"/>
>   </pm>
>   <devices>
>     <emulator>/usr/bin/qemu-system-x86_64</emulator>
>     <disk type="block" device="disk">
>       <driver name="qemu" type="raw" cache="unsafe" discard="unmap"
> detect_zeroes="unmap"/>
>       <source dev="/dev/disk/by-partuuid/05c3750b-060f-4703-95ea-6f5e546bf6e9"/>
>       <target dev="vda" bus="virtio"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x0a"
> function="0x0"/>
>     </disk>
>     <controller type="pci" index="0" model="pcie-root"/>
>     <controller type="pci" index="1" model="pcie-root-port">
>       <model name="pcie-root-port"/>
>       <target chassis="1" port="0x8"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x01"
> function="0x0" multifunction="on"/>
>     </controller>
>     <controller type="pci" index="2" model="pcie-root-port">
>       <model name="pcie-root-port"/>
>       <target chassis="2" port="0x9"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x01"
> function="0x1"/>
>     </controller>
>     <controller type="pci" index="3" model="pcie-root-port">
>       <model name="pcie-root-port"/>
>       <target chassis="3" port="0xa"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x01"
> function="0x2"/>
>     </controller>
>     <controller type="pci" index="4" model="pcie-root-port">
>       <model name="pcie-root-port"/>
>       <target chassis="4" port="0xb"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x01"
> function="0x3"/>
>     </controller>
>     <controller type="pci" index="5" model="pcie-to-pci-bridge">
>       <model name="pcie-pci-bridge"/>
>       <address type="pci" domain="0x0000" bus="0x02" slot="0x00"
> function="0x0"/>
>     </controller>
>     <controller type="usb" index="0" model="qemu-xhci">
>       <address type="pci" domain="0x0000" bus="0x01" slot="0x00"
> function="0x0"/>
>     </controller>
>     <controller type="sata" index="0">
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x1f"
> function="0x2"/>
>     </controller>
>     <interface type="network">
>       <mac address="52:54:00:c6:bb:bc"/>
>       <source network="default"/>
>       <model type="e1000"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x03"
> function="0x0"/>
>     </interface>
>     <input type="mouse" bus="ps2"/>
>     <input type="keyboard" bus="ps2"/>
>     <sound model="ich9">
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x04"
> function="0x0"/>
>     </sound>
>     <hostdev mode="subsystem" type="pci" managed="yes">
>       <source>
>         <address domain="0x0000" bus="0x00" slot="0x02" function="0x0"/>
>       </source>
>       <rom bar="off"/>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x02"
> function="0x0"/>
>     </hostdev>
>     <memballoon model="virtio">
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x08"
> function="0x0"/>
>     </memballoon>
>     <rng model="virtio">
>       <backend model="random">/dev/urandom</backend>
>       <address type="pci" domain="0x0000" bus="0x00" slot="0x09"
> function="0x0"/>
>     </rng>
>   </devices>
> </domain>
> 

